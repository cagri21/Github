import SwiftUI

struct GithubSearchAutocompleteErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        GithubSearchAutocompleteStatusView(
            model: .error,
            eyebrow: L10n.searchAutocompleteErrorEyebrow,
            title: L10n.searchAutocompleteErrorTitle,
            message: message,
            buttonTitle: L10n.searchAutocompleteRetry,
            action: onRetry
        )
    }
}
