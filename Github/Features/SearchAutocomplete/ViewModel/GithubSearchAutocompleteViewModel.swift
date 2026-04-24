import Foundation

@MainActor
final class GithubSearchAutocompleteViewModel: GitViewModel<GithubSearchAutocompleteState> {
    typealias State = GithubSearchAutocompleteState

    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var nextPageErrorMessage: String?
    @Published private(set) var query = String.gitEmpty

    private let policy: GithubSearchAutocompleteViewModelPolicy
    private let runtime: GithubSearchAutocompleteViewModelRuntime
    private let useCase: GithubSearchAutocompleteUseCase

    private var pagingSession = GithubSearchAutocompletePagingSession()
    private var paginationTask: Task<Void, Never>? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(
        useCase: GithubSearchAutocompleteUseCase,
        policy: GithubSearchAutocompleteViewModelPolicy = .init(),
        runtime: GithubSearchAutocompleteViewModelRuntime = .init()
    ) {
        self.policy = policy
        self.runtime = runtime
        self.useCase = useCase
        super.init(initialState: .hint(message: Self.initialPrompt(policy.minimumQueryLength)))
    }

    var hasMoreResults: Bool {
        pagingSession.hasMoreResults
    }

    var minimumCharacterCount: Int {
        policy.minimumQueryLength
    }

    func loadNextPageIfNeeded(
        currentItem: GithubSearchAutocompleteItem
    ) {
        guard let results = state.results,
              let lastItem = results.last,
              lastItem.id == currentItem.id
        else {
            return
        }

        loadNextPage()
    }

    func retry() {
        scheduleSearch(for: query)
    }

    func retryNextPage() {
        loadNextPage()
    }

    func updateQuery(
        _ newValue: String
    ) {
        query = newValue
        scheduleSearch(for: newValue)
    }

    func clearQuery() {
        updateQuery(.gitEmpty)
    }
}

private extension GithubSearchAutocompleteViewModel {
    enum QueryInput {
        case emptyHint
        case minimumLengthHint
        case ready(normalizedQuery: String)
    }

    static func initialPrompt(
        _ minimumQueryLength: Int
    ) -> String {
        L10n.searchAutocompleteInitialPrompt(minimumQueryLength)
    }

    func appendBufferedSuggestions() {
        guard let results = state.results else {
            return
        }

        let nextSuggestions = pagingSession.takeNextSuggestions(
            displayPageSize: policy.displayPageSize
        )
        guard !nextSuggestions.isEmpty else {
            return
        }

        nextPageErrorMessage = nil

        let appendedItems = nextSuggestions.map(runtime.suggestionItemBuilder)
        setState(.loaded(results: sortedItems(results + appendedItems)))
    }

    @discardableResult
    func appendBufferedSuggestionsIfNeeded() -> Bool {
        guard pagingSession.hasBufferedSuggestions else {
            return false
        }

        appendBufferedSuggestions()
        return true
    }

    func applyInitialBatch(
        _ batch: GithubSearchAutocompleteBatch,
        for normalizedQuery: String
    ) {
        nextPageErrorMessage = nil

        let displayedSuggestions = pagingSession.applyInitialBatch(
            batch,
            displayPageSize: policy.displayPageSize
        )
        let items = sortedItems(displayedSuggestions.map(runtime.suggestionItemBuilder))
        setState(
            items.isEmpty
                ? .empty(message: L10n.searchAutocompleteNoResultsFor(normalizedQuery))
                : .loaded(results: items)
        )
    }

    func applyNextPageBatch(
        _ batch: GithubSearchAutocompleteBatch,
        page: Int
    ) {
        pagingSession.enqueueRemoteBatch(batch, page: page)
        isLoadingNextPage = false
        appendBufferedSuggestions()
    }

    func cancelActiveTasks() {
        task = nil
        paginationTask = nil
    }

    func canApplySearchResult(
        for normalizedQuery: String
    ) -> Bool {
        !Task.isCancelled && normalizedQuery == self.normalizedQuery(from: query)
    }

    func clearNextPageError() {
        nextPageErrorMessage = nil
    }

    func beginNextPageLoading() {
        isLoadingNextPage = true
        clearNextPageError()
    }

    func finishNextPageWithError() {
        isLoadingNextPage = false
        nextPageErrorMessage = L10n.searchAutocompleteErrorMessage
    }

    func loadNextPageQuery() -> String? {
        let normalizedQuery = normalizedQuery(from: query)
        guard pagingSession.hasMoreRemoteResults,
              normalizedQuery.count >= policy.minimumQueryLength else {
            return nil
        }

        return normalizedQuery
    }

    func loadNextPage() {
        guard hasMoreResults, !isLoadingNextPage else {
            return
        }

        if appendBufferedSuggestionsIfNeeded() {
            return
        }

        guard let normalizedQuery = loadNextPageQuery() else {
            return
        }

        beginNextPageLoading()

        paginationTask = Task { @MainActor [weak self] in
            guard let self else { return }

            let nextPage = pagingSession.nextPage

            do {
                let batch = try await useCase.search(query: normalizedQuery, page: nextPage)

                guard canApplySearchResult(for: normalizedQuery) else { return }

                applyNextPageBatch(batch, page: nextPage)
            } catch is CancellationError {
                return
            } catch {
                guard canApplySearchResult(for: normalizedQuery) else { return }

                finishNextPageWithError()
            }
        }
    }

    func normalizedQuery(
        from rawQuery: String
    ) -> String {
        rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func resetPagination() {
        pagingSession.reset()
        isLoadingNextPage = false
        nextPageErrorMessage = nil
    }

    func startInitialSearch(
        for normalizedQuery: String
    ) {
        setState(.loading)

        task = Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                try await runtime.sleep(policy.searchDelay)

                let batch = try await useCase.search(
                    query: normalizedQuery,
                    page: GithubSearchAutocompleteConfiguration.Search.initialPage
                )

                guard canApplySearchResult(for: normalizedQuery) else { return }

                applyInitialBatch(batch, for: normalizedQuery)
            } catch is CancellationError {
                return
            } catch {
                guard canApplySearchResult(for: normalizedQuery) else { return }

                resetPagination()
                setState(.error(message: L10n.searchAutocompleteErrorMessage))
            }
        }
    }

    func queryInput(
        from rawQuery: String
    ) -> QueryInput {
        let normalizedQuery = normalizedQuery(from: rawQuery)

        guard !normalizedQuery.isEmpty else {
            return .emptyHint
        }

        guard normalizedQuery.count >= policy.minimumQueryLength else {
            return .minimumLengthHint
        }

        return .ready(normalizedQuery: normalizedQuery)
    }

    func scheduleSearch(
        for rawQuery: String
    ) {
        cancelActiveTasks()
        resetPagination()

        switch queryInput(from: rawQuery) {
        case .emptyHint:
            setState(.hint(message: Self.initialPrompt(policy.minimumQueryLength)))
        case .minimumLengthHint:
            setState(.hint(message: L10n.searchAutocompleteKeepTyping(policy.minimumQueryLength)))
        case let .ready(normalizedQuery):
            startInitialSearch(for: normalizedQuery)
        }
    }

    func sortedItems(
        _ items: [GithubSearchAutocompleteItem]
    ) -> [GithubSearchAutocompleteItem] {
        items.sorted { lhs, rhs in
            lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }
}
