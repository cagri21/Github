import SwiftUI

struct GithubSearchAutocompleteHintView: View {
    let minimumCharacterCount: Int
    let message: String

    var body: some View {
        let title = L10n.searchAutocompleteIdleTitle(minimumCharacterCount)

        GithubSearchAutocompleteStatusView(
            model: .hint,
            eyebrow: title,
            title: title,
            message: message
        )
    }
}
