import SwiftUI

struct GithubSearchAutocompleteResultsView: View {
    let hasMoreResults: Bool
    let isLoadingNextPage: Bool
    let items: [GithubSearchAutocompleteItem]
    let nextPageErrorMessage: String?
    let onLoadNextPage: () -> Void
    let onLoadNextPageIfNeeded: (GithubSearchAutocompleteItem) -> Void
    let onSelect: (GithubSearchAutocompleteItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: GitAppLayout.List.sectionSpacing) {
            Text(L10n.searchAutocompleteResultsCount(items.count))
                .font(GitVisualTheme.font(size: GitAppLayout.List.resultsCountFontSize))
                .foregroundStyle(GitVisualTheme.secondaryText)
                .padding(.top, GitAppLayout.List.topPadding)
                .accessibilityIdentifier(GithubSearchAutocompleteAccessibilityID.resultsCount)

            ScrollView {
                LazyVStack(spacing: GitAppLayout.List.listSpacing) {
                    ForEach(items) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            GithubSearchAutocompleteRowView(item: item)
                        }
                        .onAppear {
                            onLoadNextPageIfNeeded(item)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier(
                            GithubSearchAutocompleteAccessibilityID.resultRow(item.id)
                        )
                    }

                    Text(L10n.searchAutocompleteResultsSummary(items.count, items.count))
                        .font(GitVisualTheme.font(size: GitAppLayout.List.summaryFontSize))
                        .foregroundStyle(GitVisualTheme.tertiaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.top, GitAppLayout.List.summaryTopPadding)
                        .padding(.bottom, GitAppLayout.List.summaryBottomPadding)

                    if isLoadingNextPage {
                        ProgressView()
                            .tint(GitVisualTheme.accentBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, GitAppLayout.List.summaryBottomPadding)
                    } else if hasMoreResults, nextPageErrorMessage != nil {
                        Button(L10n.searchAutocompleteRetry) {
                            onLoadNextPage()
                        }
                        .font(
                            GitVisualTheme.font(
                                size: GitAppLayout.List.nextPageRetryFontSize,
                                weight: .bold
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, GitAppLayout.List.summaryBottomPadding)
                    }
                }
            }
            .accessibilityIdentifier(GithubSearchAutocompleteAccessibilityID.resultsList)
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
