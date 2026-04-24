import SwiftUI

extension GitSearchBarStyle {
    static var gitPrimary: GitSearchBarStyle {
        GitSearchBarStyle(
            typography: GitSearchBarTypographyStyle(
                textFont: GitVisualTheme.font(
                    size: GitAppLayout.SearchField.textFontSize,
                    weight: .bold
                ),
                cancelFont: GitVisualTheme.font(
                    size: GitAppLayout.SearchField.cancelLabelFontSize
                )
            ),
            colors: GitSearchBarColorStyle(
                iconColor: GitVisualTheme.secondaryText,
                textColor: GitVisualTheme.primaryText,
                placeholderColor: GitVisualTheme.mutedText,
                tintColor: GitVisualTheme.accentBlue,
                clearIconColor: GitVisualTheme.secondaryText,
                cancelColor: GitVisualTheme.accentBlue
            ),
            layout: GitSearchBarLayoutStyle(
                fieldSpacing: GitAppLayout.SearchField.contentSpacing,
                stackSpacing: GitAppLayout.SearchField.stackSpacing,
                horizontalPadding: GitAppLayout.SearchField.horizontalPadding,
                fieldHeight: GitAppLayout.SearchField.height
            ),
            icons: GitSearchBarIconStyle(
                iconSize: GitAppLayout.SearchField.iconSize,
                clearIconSize: GitAppLayout.SearchField.clearIconSize
            ),
            surfaceStyle: GitSurfaceCardStyle(
                shape: GitSurfaceCardShapeStyle(
                    cornerRadius: GitAppTheme.CornerRadius.small
                ),
                fill: GitSurfaceCardFillStyle(
                    color: GitVisualTheme.searchFill
                ),
                border: GitSurfaceCardBorderStyle(
                    color: GitVisualTheme.searchBorder,
                    width: GitAppTheme.BorderWidth.regular
                ),
                shadow: GitSurfaceCardShadowStyle(
                    color: GitVisualTheme.accentPurple.opacity(
                        GitVisualTheme.SearchField.shadowOpacity
                    ),
                    radius: GitAppLayout.SearchField.shadowRadius
                )
            )
        )
    }
}
