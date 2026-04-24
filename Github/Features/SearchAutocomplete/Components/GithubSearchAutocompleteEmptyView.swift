import SwiftUI

struct GithubSearchAutocompleteEmptyView: View {
    let message: String

    var body: some View {
        GithubSearchAutocompleteStatusView(
            model: .empty,
            eyebrow: L10n.searchAutocompleteEmptyEyebrow,
            title: L10n.searchAutocompleteEmptyTitle,
            message: message
        )
    }
}
