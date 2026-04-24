import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) private var openURL

    @StateObject private var viewModel: GithubSearchAutocompleteViewModel

    init(
        viewModel: GithubSearchAutocompleteViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GithubSearchAutocompleteView(viewModel: viewModel) { item in
            openURL(item.destinationURL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
