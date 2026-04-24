@testable import Github
import GithubAPI

actor SearchServiceSpy: SearchService {
    let repositoryPages: [Int: [GithubRepositorySummary]]
    let userPages: [Int: [GithubUserProfile]]
    private var repositoryLimits = [Int]()
    private var repositoryPagesRequested = [Int]()
    private var userLimits = [Int]()
    private var userPagesRequested = [Int]()

    init(
        repositoryPages: [Int: [GithubRepositorySummary]],
        userPages: [Int: [GithubUserProfile]]
    ) {
        self.repositoryPages = repositoryPages
        self.userPages = userPages
    }

    func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        repositoryLimits.append(limit)
        repositoryPagesRequested.append(page)
        return Array((repositoryPages[page] ?? []).prefix(limit))
    }

    func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        userLimits.append(limit)
        userPagesRequested.append(page)
        return Array((userPages[page] ?? []).prefix(limit))
    }

    func recordedRepositoryLimits() -> [Int] {
        repositoryLimits
    }

    func recordedRepositoryPages() -> [Int] {
        repositoryPagesRequested
    }

    func recordedUserLimits() -> [Int] {
        userLimits
    }

    func recordedUserPages() -> [Int] {
        userPagesRequested
    }
}

actor SearchUseCaseSpy: GithubSearchAutocompleteUseCase {
    private var pages = [Int]()
    private var queries = [String]()

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        pages.append(page)
        queries.append(query)
        return GithubSearchAutocompleteBatch(
            suggestions: [],
            hasMoreResults: false
        )
    }

    func recordedQueries() -> [String] {
        queries
    }

    func recordedPages() -> [Int] {
        pages
    }
}

actor SearchUseCaseRecordingStub: GithubSearchAutocompleteUseCase {
    typealias Request = (query: String, page: Int)

    private let handler: @Sendable (String, Int) async throws -> GithubSearchAutocompleteBatch
    private var requests = [Request]()

    init(
        handler: @escaping @Sendable (String, Int) async throws -> GithubSearchAutocompleteBatch
    ) {
        self.handler = handler
    }

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        requests.append((query: query, page: page))
        return try await handler(query, page)
    }

    func recordedRequests() -> [Request] {
        requests
    }
}

struct SearchUseCaseStub: GithubSearchAutocompleteUseCase {
    let handler: @Sendable (String, Int) async throws -> GithubSearchAutocompleteBatch

    func search(
        query: String,
        page: Int
    ) async throws -> GithubSearchAutocompleteBatch {
        try await handler(query, page)
    }
}

struct SearchServiceResultStub: SearchService {
    let repositories: Result<[GithubRepositorySummary], Error>
    let users: Result<[GithubUserProfile], Error>

    func searchRepositories(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubRepositorySummary] {
        try repositories.get()
    }

    func searchUsers(
        query: String,
        limit: Int,
        page: Int
    ) async throws -> [GithubUserProfile] {
        try users.get()
    }
}

struct SearchServiceTestError: Error {}

func waitForViewModelTasks() async throws {
    try await Task.sleep(for: .milliseconds(40))
}
