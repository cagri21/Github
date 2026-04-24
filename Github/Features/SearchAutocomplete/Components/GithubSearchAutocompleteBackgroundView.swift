import SwiftUI

struct GithubSearchAutocompleteBackgroundView: View {
    var body: some View {
        ZStack {
            GitGradientBackground(
                colors: [
                    GitVisualTheme.backgroundTop,
                    GitVisualTheme.backgroundBottom
                ]
            )

            GitStarfield(
                color: GitVisualTheme.star,
                stars: GitVisualTheme.Background.stars
            )
                .opacity(GitVisualTheme.Background.starfieldOpacity)
                .ignoresSafeArea()

            GitPerspectiveGrid(
                lineColor: GitVisualTheme.gridLine,
                style: gridStyle
            )
                .ignoresSafeArea()
        }
    }
}

private extension GithubSearchAutocompleteBackgroundView {
    var gridStyle: GitPerspectiveGridStyle {
        GitPerspectiveGridStyle(
            geometry: GitPerspectiveGridGeometry(
                horizonRatio: GitVisualTheme.Grid.horizonRatio,
                horizontalLineCount: GitVisualTheme.Grid.horizontalLineCount,
                rowSpacing: GitAppLayout.Grid.lineSpacing
            ),
            line: GitPerspectiveGridLineStyle(
                lineWidth: GitVisualTheme.Grid.lineWidth,
                horizontalOpacity: GitVisualTheme.Grid.horizontalOpacity,
                verticalOpacity: GitVisualTheme.Grid.verticalOpacity
            ),
            vertical: GitPerspectiveGridVerticalStyle(
                lineRange: GitVisualTheme.Grid.verticalLineRange,
                horizonSpacing: GitVisualTheme.Grid.verticalHorizonSpacing,
                bottomSpacing: GitVisualTheme.Grid.verticalBottomSpacing
            )
        )
    }
}
