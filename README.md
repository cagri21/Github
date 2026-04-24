# Github Search Challenge

This repo contains a reusable SwiftUI autocomplete component that:

- starts searching after 3 characters
- fetches 50 GitHub users and 50 GitHub repositories from page 1
- combines them into one alphabetically sorted list
- shows loading, empty, and error feedback
- debounces rapid input changes and ignores stale responses

## Architecture

The implementation follows the local project rules:

- `Github/Features/SearchAutocomplete` contains the SwiftUI feature
- `Packages/GithubAPI/API/SearchAPI` contains the layered service, repository, network, request, entity, and mapping code
- `Packages/CommonData` remains the shared transport layer

## Test Snippet

The repo includes Swift Testing coverage in `GithubTests/GithubSearchAutocompleteTests.swift`.

## Optional GitHub Token

Authenticated GitHub search requests can use a fine-grained personal access token through a local, ignored config file:

```xcconfig
// Github/Core/Configs/Secrets.xcconfig
GIT_API_KEY = your_rotated_token_here
```

Do not commit real tokens. If a token is shared in chat, rotate it before using it locally.

```swift
@Test func keepsOnlyLatestResultsDuringRapidInputChanges() async throws {
    let useCase = SearchUseCaseStub { query in
        if query == "swift" {
            try await Task.sleep(for: .milliseconds(80))
            return [
                GithubSearchSuggestion(
                    avatarURL: nil,
                    destinationURL: URL(string: "https://github.com/apple/swift")!,
                    detailText: nil,
                    id: "repository-swift",
                    kind: .repository,
                    subtitle: "apple",
                    title: "Swift"
                )
            ]
        }

        return [
            GithubSearchSuggestion(
                avatarURL: nil,
                destinationURL: URL(string: "https://github.com/apple/swiftui")!,
                detailText: nil,
                id: "repository-swiftui",
                kind: .repository,
                subtitle: "apple",
                title: "SwiftUI"
            )
        ]
    }

    let viewModel = GithubSearchAutocompleteViewModel(
        useCase: useCase,
        searchDelay: .zero,
        sleep: { _ in }
    )

    viewModel.updateQuery("swift")
    viewModel.updateQuery("swiftui")

    try await Task.sleep(for: .milliseconds(140))

    if case let .results(items) = viewModel.state {
        #expect(items.map(\.title) == ["SwiftUI"])
    }
}
```

To publish the challenge artifact, push this repository to a public Git host and share that repository URL.
