// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
  }
  internal enum Colors {
    internal static let searchAutocompleteAccentBlue = ColorAsset(name: "SearchAutocompleteAccentBlue")
    internal static let searchAutocompleteAccentCyan = ColorAsset(name: "SearchAutocompleteAccentCyan")
    internal static let searchAutocompleteAccentMint = ColorAsset(name: "SearchAutocompleteAccentMint")
    internal static let searchAutocompleteAccentPink = ColorAsset(name: "SearchAutocompleteAccentPink")
    internal static let searchAutocompleteAccentPurple = ColorAsset(name: "SearchAutocompleteAccentPurple")
    internal static let searchAutocompleteBackgroundBottom = ColorAsset(name: "SearchAutocompleteBackgroundBottom")
    internal static let searchAutocompleteBackgroundTop = ColorAsset(name: "SearchAutocompleteBackgroundTop")
    internal static let searchAutocompleteDanger = ColorAsset(name: "SearchAutocompleteDanger")
    internal static let searchAutocompleteGradientStart = ColorAsset(name: "SearchAutocompleteGradientStart")
    internal static let searchAutocompleteGridLine = ColorAsset(name: "SearchAutocompleteGridLine")
    internal static let searchAutocompleteJavaScriptDot = ColorAsset(name: "SearchAutocompleteJavaScriptDot")
    internal static let searchAutocompleteMutedText = ColorAsset(name: "SearchAutocompleteMutedText")
    internal static let searchAutocompletePrimaryText = ColorAsset(name: "SearchAutocompletePrimaryText")
    internal static let searchAutocompletePythonDot = ColorAsset(name: "SearchAutocompletePythonDot")
    internal static let searchAutocompleteRepositoryBadgeFill = ColorAsset(name: "SearchAutocompleteRepositoryBadgeFill")
    internal static let searchAutocompleteRowFill = ColorAsset(name: "SearchAutocompleteRowFill")
    internal static let searchAutocompleteRowStroke = ColorAsset(name: "SearchAutocompleteRowStroke")
    internal static let searchAutocompleteSearchBorder = ColorAsset(name: "SearchAutocompleteSearchBorder")
    internal static let searchAutocompleteSearchFill = ColorAsset(name: "SearchAutocompleteSearchFill")
    internal static let searchAutocompleteSecondaryText = ColorAsset(name: "SearchAutocompleteSecondaryText")
    internal static let searchAutocompleteStar = ColorAsset(name: "SearchAutocompleteStar")
    internal static let searchAutocompleteSwiftDot = ColorAsset(name: "SearchAutocompleteSwiftDot")
    internal static let searchAutocompleteTertiaryText = ColorAsset(name: "SearchAutocompleteTertiaryText")
    internal static let searchAutocompleteUserBadgeFill = ColorAsset(name: "SearchAutocompleteUserBadgeFill")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

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
