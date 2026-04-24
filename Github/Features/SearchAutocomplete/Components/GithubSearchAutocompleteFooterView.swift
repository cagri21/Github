import SwiftUI

struct GithubSearchAutocompleteFooterView: View {
    let title: String

    var body: some View {
        VStack(spacing: GitAppLayout.Shared.zero) {
            GitFloorGlow(
                colors: [
                    GitVisualTheme.accentPurple.opacity(GitVisualTheme.Background.footerGlowPrimaryOpacity),
                    GitVisualTheme.accentPurple.opacity(GitVisualTheme.Background.footerGlowSecondaryOpacity),
                    .clear
                ],
                startRadius: GitAppLayout.Background.floorGlowStartRadius,
                endRadius: GitAppLayout.Background.floorGlowEndRadius,
                blurRadius: GitAppLayout.Background.floorGlowBlurRadius,
                maxWidth: GitAppLayout.Background.floorGlowMaxWidth,
                maxHeight: GitAppLayout.Background.floorGlowHeight
            )
                .frame(height: GitAppLayout.Footer.floorGlowHeight)
                .padding(.bottom, GitAppLayout.Footer.floorGlowBottomPadding)

            Text(title)
                .font(GitVisualTheme.font(size: GitAppLayout.Footer.titleFontSize))
                .foregroundStyle(GitVisualTheme.secondaryText)
                .frame(height: GitAppLayout.Footer.titleHeight)
            .padding(.bottom, GitAppLayout.Footer.bottomPadding)
        }
    }
}
