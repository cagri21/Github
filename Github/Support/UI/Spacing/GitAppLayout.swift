import CoreGraphics

enum GitAppLayout {
    enum Shared {
        static let zero: CGFloat = GitSpacing.zero
    }

    enum Screen {
        static let topInset: CGFloat = GitSpacing.small
        static let horizontalInset: CGFloat = GitSpacing.medium
    }

    enum SearchField {
        static let cancelLabelFontSize: CGFloat = 15
        static let clearIconSize: CGFloat = 13
        static let shadowRadius: CGFloat = 12
        static let horizontalPadding: CGFloat = 10
        static let iconSize: CGFloat = 13
        static let height: CGFloat = 30
        static let contentSpacing: CGFloat = GitSpacing.small
        static let stackSpacing: CGFloat = GitSpacing.medium
        static let textFontSize: CGFloat = 15
    }

    enum List {
        static let listSpacing: CGFloat = GitSpacing.small
        static let nextPageRetryFontSize: CGFloat = 12
        static let resultsCountFontSize: CGFloat = 15
        static let sectionSpacing: CGFloat = GitSpacing.mediumPlus
        static let summaryBottomPadding: CGFloat = GitSpacing.small
        static let summaryFontSize: CGFloat = 15
        static let summaryTopPadding: CGFloat = 26
        static let topPadding: CGFloat = 15
    }

    enum State {
        static let buttonTopPadding: CGFloat = 10
        static let buttonWidth: CGFloat = 76
        static let buttonHeight: CGFloat = 28
        static let contentBottomPadding: CGFloat = 42
        static let contentSpacing: CGFloat = GitSpacing.medium
        static let eyebrowFontSize: CGFloat = 12
        static let eyebrowTopPadding: CGFloat = GitSpacing.mediumPlus
        static let glyphBottomPadding: CGFloat = GitSpacing.xxLarge
        static let glyphSize: CGFloat = 132
        static let messageFontSize: CGFloat = 13
        static let ringBaseSize: CGFloat = 74
        static let ringBlurStep: CGFloat = 2
        static let ringCount = 3
        static let ringSizeStep: CGFloat = 32
        static let ringStrokeWidth: CGFloat = 1
        static let retryFontSize: CGFloat = 12
        static let statusGlowSize: CGFloat = 64
        static let titleFontSize: CGFloat = 19
        static let glowBlurRadius: CGFloat = 16
        static let primaryShadowRadius: CGFloat = 16
        static let secondaryShadowRadius: CGFloat = 34
        static let retryShadowRadius: CGFloat = 18
    }

    enum Footer {
        static let bottomPadding: CGFloat = 14
        static let floorGlowBottomPadding: CGFloat = GitSpacing.small
        static let floorGlowHeight: CGFloat = 72
        static let titleFontSize: CGFloat = 12
        static let titleHeight: CGFloat = 20
    }

    enum Row {
        static let accessoryChevronSize: CGFloat = 12
        static let avatarFallbackIconSize: CGFloat = 16
        static let badgeFontSize: CGFloat = 11
        static let badgeHeight: CGFloat = 20
        static let badgeHorizontalPadding: CGFloat = GitSpacing.medium
        static let contentSpacing: CGFloat = GitSpacing.mediumPlus
        static let horizontalPadding: CGFloat = GitSpacing.medium
        static let iconFrameSize: CGFloat = 34
        static let iconShadowRadius: CGFloat = 9
        static let languageSpacing: CGFloat = 6
        static let languageDotSize: CGFloat = 6
        static let metadataFontSize: CGFloat = 12
        static let metricsSpacing: CGFloat = GitSpacing.mediumPlus
        static let repositoryAccessoryWidth: CGFloat = 106
        static let repositoryContentSpacing: CGFloat = GitSpacing.xxSmall
        static let repositoryMinHeight: CGFloat = 68
        static let repositoryTitleFontSize: CGFloat = 17
        static let starIconSize: CGFloat = 10
        static let starSpacing: CGFloat = GitSpacing.xxSmall
        static let subtitleFontSize: CGFloat = 14
        static let surfaceShadowRadius: CGFloat = 12
        static let titleFontSize: CGFloat = 19
        static let trailingSpacing: CGFloat = GitSpacing.small
        static let userAccessoryWidth: CGFloat = 78
        static let userMinHeight: CGFloat = 61
    }

    enum Grid {
        static let lineSpacing: CGFloat = 18
    }

    enum Text {
        static let lineSpacing: CGFloat = GitSpacing.hairline
    }

    enum Background {
        static let floorGlowBlurRadius: CGFloat = 12
        static let floorGlowEndRadius: CGFloat = 116
        static let floorGlowHeight: CGFloat = 44
        static let floorGlowMaxWidth: CGFloat = 230
        static let floorGlowStartRadius: CGFloat = 4
        static let largeStarSize: CGFloat = 2
        static let loadingOrbitBarHeight: CGFloat = 6
        static let loadingOrbitBarOffsetX: CGFloat = 24
        static let loadingOrbitBarWidth: CGFloat = 58
        static let loadingOrbitCircleLineWidth: CGFloat = 2
        static let loadingOrbitGlyphSize: CGFloat = 24
        static let loadingOrbitGlyphShadowRadius: CGFloat = 18
        static let loadingOrbitSize: CGFloat = 74
        static let sparkleSize: CGFloat = 10
        static let starGlowRadius: CGFloat = 8
        static let starSize: CGFloat = 1
        static let statusSymbolSize: CGFloat = 46
    }
}
