import SwiftUI

struct GithubSearchAutocompleteView: View {
    @ObservedObject var viewModel: GithubSearchAutocompleteViewModel

    let onSelect: (GithubSearchAutocompleteItem) -> Void

    var body: some View {
        GithubSearchAutocompleteContainerView(
            actions: .init(
                viewModel: viewModel,
                onSelect: onSelect
            ),
            props: .init(viewModel: viewModel)
        )
    }
}
