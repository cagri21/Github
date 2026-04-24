import SwiftUI

enum GithubSearchRepositoryLanguage: String, Equatable, Sendable {
    case golang = "go"
    case javaScript = "javascript"
    case kotlin
    case python
    case ruby
    case swift
    case typeScript = "typescript"

    init?(
        displayName: String
    ) {
        let normalizedName = displayName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        self.init(rawValue: normalizedName)
    }

    var dotColor: Color {
        switch self {
        case .swift:
            GitVisualTheme.swiftDot
        case .kotlin:
            GitVisualTheme.accentPurple
        case .javaScript:
            GitVisualTheme.javaScriptDot
        case .typeScript:
            GitVisualTheme.accentBlue
        case .python:
            GitVisualTheme.pythonDot
        case .ruby:
            GitVisualTheme.danger
        case .golang:
            GitVisualTheme.accentCyan
        }
    }

    static func dotColor(
        for displayName: String
    ) -> Color {
        GithubSearchRepositoryLanguage(displayName: displayName)?.dotColor
            ?? GitVisualTheme.tertiaryText
    }
}
