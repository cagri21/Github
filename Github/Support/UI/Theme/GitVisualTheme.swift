import SwiftUI

enum GitVisualTheme {
    static let backgroundTop = Asset.Colors.searchAutocompleteBackgroundTop.swiftUIColor
    static let backgroundBottom = Asset.Colors.searchAutocompleteBackgroundBottom.swiftUIColor
    static let searchFill = Asset.Colors.searchAutocompleteSearchFill.swiftUIColor
    static let searchBorder = Asset.Colors.searchAutocompleteSearchBorder.swiftUIColor
    static let rowFill = Asset.Colors.searchAutocompleteRowFill.swiftUIColor
    static let rowStroke = Asset.Colors.searchAutocompleteRowStroke.swiftUIColor
    static let userBadgeFill = Asset.Colors.searchAutocompleteUserBadgeFill.swiftUIColor
    static let repositoryBadgeFill = Asset.Colors.searchAutocompleteRepositoryBadgeFill.swiftUIColor
    static let retryGradient = LinearGradient(
        colors: [
            Asset.Colors.searchAutocompleteGradientStart.swiftUIColor,
            Asset.Colors.searchAutocompleteAccentPurple.swiftUIColor,
            Asset.Colors.searchAutocompleteGradientStart.swiftUIColor
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let primaryText = Asset.Colors.searchAutocompletePrimaryText.swiftUIColor
    static let secondaryText = Asset.Colors.searchAutocompleteSecondaryText.swiftUIColor
    static let tertiaryText = Asset.Colors.searchAutocompleteTertiaryText.swiftUIColor
    static let mutedText = Asset.Colors.searchAutocompleteMutedText.swiftUIColor
    static let metricText = Asset.Colors.searchAutocompleteMutedText.swiftUIColor
    static let star = Asset.Colors.searchAutocompleteStar.swiftUIColor
    static let gridLine = Asset.Colors.searchAutocompleteGridLine.swiftUIColor

    static let accentBlue = Asset.Colors.searchAutocompleteAccentBlue.swiftUIColor
    static let accentCyan = Asset.Colors.searchAutocompleteAccentCyan.swiftUIColor
    static let accentMint = Asset.Colors.searchAutocompleteAccentMint.swiftUIColor
    static let accentPink = Asset.Colors.searchAutocompleteAccentPink.swiftUIColor
    static let accentPurple = Asset.Colors.searchAutocompleteAccentPurple.swiftUIColor
    static let danger = Asset.Colors.searchAutocompleteDanger.swiftUIColor
    static let swiftDot = Asset.Colors.searchAutocompleteSwiftDot.swiftUIColor
    static let javaScriptDot = Asset.Colors.searchAutocompleteJavaScriptDot.swiftUIColor
    static let pythonDot = Asset.Colors.searchAutocompletePythonDot.swiftUIColor

    static func font(
        size: CGFloat,
        weight: SwiftUI.Font.Weight = .regular
    ) -> SwiftUI.Font {
        GitAppTheme.Typography.font(size: size, weight: weight)
    }

    enum Action {
        static let retryBorderOpacity = 0.45
        static let retryShadowOpacity = 0.55
    }

    enum Background {
        static let footerGlowPrimaryOpacity = 0.50
        static let footerGlowSecondaryOpacity = 0.18
        static let starfieldOpacity = 0.82

        static let stars: [GitStarfieldStar] = [
            GitVisualTheme.star(x: 0.08, y: 0.08, size: GitAppLayout.Background.starSize, opacity: StateGlyph.brightOpacity),
            GitVisualTheme.star(x: 0.23, y: 0.15, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.41, y: 0.09, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.77, y: 0.13, size: GitAppLayout.Background.starSize, opacity: StateGlyph.brightOpacity),
            GitVisualTheme.star(x: 0.92, y: 0.24, size: GitAppLayout.Background.largeStarSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.14, y: 0.31, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.52, y: 0.29, size: GitAppLayout.Background.starSize, opacity: StateGlyph.brightOpacity),
            GitVisualTheme.star(x: 0.82, y: 0.37, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.06, y: 0.49, size: GitAppLayout.Background.largeStarSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.38, y: 0.52, size: GitAppLayout.Background.starSize, opacity: StateGlyph.brightOpacity),
            GitVisualTheme.star(x: 0.65, y: 0.47, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.94, y: 0.56, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.16, y: 0.67, size: GitAppLayout.Background.largeStarSize, opacity: StateGlyph.brightOpacity),
            GitVisualTheme.star(x: 0.47, y: 0.72, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.74, y: 0.66, size: GitAppLayout.Background.starSize, opacity: StateGlyph.dimOpacity),
            GitVisualTheme.star(x: 0.86, y: 0.78, size: GitAppLayout.Background.starSize, opacity: StateGlyph.brightOpacity)
        ]
    }

    enum Grid {
        static let horizontalLineCount: ClosedRange<Int> = 0 ... 14
        static let horizonRatio: CGFloat = 0.78
        static let horizontalOpacity = 0.17
        static let lineWidth: CGFloat = 0.7
        static let verticalBottomSpacing: CGFloat = 58
        static let verticalHorizonSpacing: CGFloat = 7
        static let verticalLineRange: ClosedRange<Int> = -8 ... 8
        static let verticalOpacity = 0.14
    }

    enum Motion {
        static let avatarTransitionDuration = 0.18
        static let loadingOrbitRotationDuration = 1.6
    }

    enum Row {
        static let avatarBackgroundOpacity = 0.7
        static let repositoryBorderOpacity = 0.95
        static let repositoryShadowOpacity = 0.25
        static let surfaceShadowOpacity = 0.10
        static let userBorderOpacity = 0.9
        static let userShadowOpacity = 0.30
    }

    enum SearchField {
        static let shadowOpacity = 0.25
    }

    enum StateGlyph {
        static let brightOpacity = 0.65
        static let dimOpacity = 0.35
        static let glowOpacity = 0.09
        static let loadingAccentOpacity = 0.95
        static let loadingGlyphOpacity = 0.65
        static let loadingOrbitStartOpacity = 0.05
        static let loadingOrbitStrokeOpacity = 0.10
        static let ringBaseOpacity = 0.10
        static let ringOpacityStep = 0.02
        static let secondaryShadowOpacity = 0.35
        static let symbolOpacity = 0.75
    }

    private static func star(
        x: CGFloat,
        y: CGFloat,
        size: CGFloat,
        opacity: Double
    ) -> GitStarfieldStar {
        GitStarfieldStar(
            position: CGPoint(x: x, y: y),
            size: size,
            opacity: opacity
        )
    }
}
