import Foundation

enum GithubSearchAutocompleteState: Equatable {
    case hint(message: String)
    case loading
    case loaded(results: [GithubSearchAutocompleteItem])
    case empty(message: String)
    case error(message: String)
}

extension GithubSearchAutocompleteState: GitStateRepresentable {
    var gitState: GitState<[GithubSearchAutocompleteItem]> {
        switch self {
        case let .hint(message):
            .idle(message: message)
        case .loading:
            .loading
        case let .loaded(results):
            .data(results)
        case let .empty(message):
            .empty(message: message)
        case let .error(message):
            .error(message: message)
        }
    }

    var results: [GithubSearchAutocompleteItem]? {
        value
    }
}
