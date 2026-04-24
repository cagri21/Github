import Foundation

enum GithubSearchAutocompletePreviewData {
    static let sampleItems: [GithubSearchAutocompleteItem] = [
        GithubSearchAutocompleteItem(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/6510388?v=4"),
            destinationURL: URL(string: "https://github.com/swiftui-lab")!,
            detailText: nil,
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.user.makeID("swiftui-lab"),
            kind: .user,
            primaryLanguage: nil,
            starCount: nil,
            subtitle: "Developer",
            title: "swiftui-lab"
        ),
        GithubSearchAutocompleteItem(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/68542775?v=4"),
            destinationURL: URL(string: "https://github.com/SwiftUIX")!,
            detailText: nil,
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.user.makeID("swiftuix"),
            kind: .user,
            primaryLanguage: nil,
            starCount: nil,
            subtitle: "iOS Developer",
            title: "SwiftUIX"
        ),
        GithubSearchAutocompleteItem(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/24435320?v=4"),
            destinationURL: URL(string: "https://github.com/amosgyamfi/swiftui-animation")!,
            detailText: "A collection of animation examples and components for SwiftUI.",
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.repository.makeID("swiftui-animations"),
            kind: .repository,
            primaryLanguage: "Swift",
            starCount: 4_200,
            subtitle: "amosgyamfi",
            title: "swiftui-animations"
        ),
        GithubSearchAutocompleteItem(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/43388?v=4"),
            destinationURL: URL(string: "https://github.com/heckj/swiftui-notes")!,
            detailText: "My personal notes about SwiftUI.",
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.repository.makeID("swiftui-notes"),
            kind: .repository,
            primaryLanguage: "Swift",
            starCount: 1_100,
            subtitle: "heckj",
            title: "swiftui-notes"
        ),
        GithubSearchAutocompleteItem(
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/1409041?v=4"),
            destinationURL: URL(string: "https://github.com/Juanpe/About-SwiftUI")!,
            detailText: "A curated list of awesome SwiftUI components and libraries.",
            id: GithubSearchAutocompleteConfiguration.SuggestionIdentifierPrefix.repository.makeID("awesome-swiftui"),
            kind: .repository,
            primaryLanguage: "Swift",
            starCount: 7_600,
            subtitle: "Juanpe",
            title: "Awesome-SwiftUI"
        )
    ]
}
