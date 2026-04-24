// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Github
  internal static let appName = L10n.tr("Localizable", "app_name", fallback: "Github")
  /// Repository
  internal static let searchAutocompleteBadgeRepository = L10n.tr("Localizable", "search_autocomplete_badge_repository", fallback: "Repository")
  /// User
  internal static let searchAutocompleteBadgeUser = L10n.tr("Localizable", "search_autocomplete_badge_user", fallback: "User")
  /// Cancel
  internal static let searchAutocompleteCancel = L10n.tr("Localizable", "search_autocomplete_cancel", fallback: "Cancel")
  /// No results
  internal static let searchAutocompleteEmptyEyebrow = L10n.tr("Localizable", "search_autocomplete_empty_eyebrow", fallback: "No results")
  /// No results found
  internal static let searchAutocompleteEmptyTitle = L10n.tr("Localizable", "search_autocomplete_empty_title", fallback: "No results found")
  /// Something went wrong
  internal static let searchAutocompleteErrorEyebrow = L10n.tr("Localizable", "search_autocomplete_error_eyebrow", fallback: "Something went wrong")
  /// We could not load suggestions right now. Please try again.
  internal static let searchAutocompleteErrorMessage = L10n.tr("Localizable", "search_autocomplete_error_message", fallback: "We could not load suggestions right now. Please try again.")
  /// Failed to search
  internal static let searchAutocompleteErrorTitle = L10n.tr("Localizable", "search_autocomplete_error_title", fallback: "Failed to search")
  /// Empty State
  internal static let searchAutocompleteFooterEmpty = L10n.tr("Localizable", "search_autocomplete_footer_empty", fallback: "Empty State")
  /// Error State
  internal static let searchAutocompleteFooterError = L10n.tr("Localizable", "search_autocomplete_footer_error", fallback: "Error State")
  /// Typing Hint
  internal static let searchAutocompleteFooterHint = L10n.tr("Localizable", "search_autocomplete_footer_hint", fallback: "Typing Hint")
  /// Loading State
  internal static let searchAutocompleteFooterLoading = L10n.tr("Localizable", "search_autocomplete_footer_loading", fallback: "Loading State")
  /// Results · Futuristic Theme
  internal static let searchAutocompleteFooterResults = L10n.tr("Localizable", "search_autocomplete_footer_results", fallback: "Results · Futuristic Theme")
  /// Type at least %d characters
  internal static func searchAutocompleteIdleTitle(_ p1: Int) -> String {
    return L10n.tr("Localizable", "search_autocomplete_idle_title", p1, fallback: "Type at least %d characters")
  }
  /// Type at least %d characters to search GitHub users and repositories.
  internal static func searchAutocompleteInitialPrompt(_ p1: Int) -> String {
    return L10n.tr("Localizable", "search_autocomplete_initial_prompt", p1, fallback: "Type at least %d characters to search GitHub users and repositories.")
  }
  /// Keep typing. Search starts after %d characters.
  internal static func searchAutocompleteKeepTyping(_ p1: Int) -> String {
    return L10n.tr("Localizable", "search_autocomplete_keep_typing", p1, fallback: "Keep typing. Search starts after %d characters.")
  }
  /// Searching...
  internal static let searchAutocompleteLoadingEyebrow = L10n.tr("Localizable", "search_autocomplete_loading_eyebrow", fallback: "Searching...")
  /// Please wait
  internal static let searchAutocompleteLoadingMessage = L10n.tr("Localizable", "search_autocomplete_loading_message", fallback: "Please wait")
  /// Searching GitHub...
  internal static let searchAutocompleteLoadingTitle = L10n.tr("Localizable", "search_autocomplete_loading_title", fallback: "Searching GitHub...")
  /// No results found for "%@".
  internal static func searchAutocompleteNoResultsFor(_ p1: Any) -> String {
    return L10n.tr("Localizable", "search_autocomplete_no_results_for", String(describing: p1), fallback: "No results found for \"%@\".")
  }
  /// Search users and repositories
  internal static let searchAutocompletePlaceholder = L10n.tr("Localizable", "search_autocomplete_placeholder", fallback: "Search users and repositories")
  /// %d results
  internal static func searchAutocompleteResultsCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "search_autocomplete_results_count", p1, fallback: "%d results")
  }
  /// Showing %1$d of %2$d results
  internal static func searchAutocompleteResultsSummary(_ p1: Int, _ p2: Int) -> String {
    return L10n.tr("Localizable", "search_autocomplete_results_summary", p1, p2, fallback: "Showing %1$d of %2$d results")
  }
  /// Retry
  internal static let searchAutocompleteRetry = L10n.tr("Localizable", "search_autocomplete_retry", fallback: "Retry")
  /// %.1fm
  internal static func searchAutocompleteStarsMillions(_ p1: Float) -> String {
    return L10n.tr("Localizable", "search_autocomplete_stars_millions", p1, fallback: "%.1fm")
  }
  /// %.1fk
  internal static func searchAutocompleteStarsThousands(_ p1: Float) -> String {
    return L10n.tr("Localizable", "search_autocomplete_stars_thousands", p1, fallback: "%.1fk")
  }
  /// GitHub user
  internal static let searchAutocompleteUserSubtitle = L10n.tr("Localizable", "search_autocomplete_user_subtitle", fallback: "GitHub user")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
