import SwiftUI

struct GithubSearchAutocompleteLoadingView: View {
    var body: some View {
        GithubSearchAutocompleteStatusView(
            model: .loading,
            eyebrow: L10n.searchAutocompleteLoadingEyebrow,
            title: L10n.searchAutocompleteLoadingTitle,
            message: L10n.searchAutocompleteLoadingMessage
        )
    }
}
