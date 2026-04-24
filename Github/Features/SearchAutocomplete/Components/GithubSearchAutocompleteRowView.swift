import SwiftUI

struct GithubSearchAutocompleteRowView: View {
    let item: GithubSearchAutocompleteItem

    var body: some View {
        GitSurfaceCard(style: surfaceStyle) {
            HStack(alignment: .center, spacing: GitAppLayout.Row.contentSpacing) {
                leadingIcon

                mainContent
                    .frame(maxWidth: .infinity, alignment: .leading)

                accessory
            }
            .padding(.horizontal, GitAppLayout.Row.horizontalPadding)
            .frame(
                minHeight: item.kind == .repository
                    ? GitAppLayout.Row.repositoryMinHeight
                    : GitAppLayout.Row.userMinHeight
            )
            .contentShape(Rectangle())
        }
    }
}

private extension GithubSearchAutocompleteRowView {
    var accessory: some View {
        HStack(spacing: GitAppLayout.Row.trailingSpacing) {
            kindBadge
                .fixedSize(horizontal: true, vertical: false)

            GitDisclosureIndicator(style: disclosureIndicatorStyle)
        }
        .frame(
            width: item.kind == .repository
                ? GitAppLayout.Row.repositoryAccessoryWidth
                : GitAppLayout.Row.userAccessoryWidth,
            alignment: .trailing
        )
    }

    var badgeStyle: GitCapsuleBadgeStyle {
        GitCapsuleBadgeStyle(
            font: GitVisualTheme.font(size: GitAppLayout.Row.badgeFontSize),
            foregroundColor: badgeForeground,
            backgroundColor: badgeBackground,
            horizontalPadding: GitAppLayout.Row.badgeHorizontalPadding,
            height: GitAppLayout.Row.badgeHeight
        )
    }

    var badgeBackground: Color {
        item.kind == .user
            ? GitVisualTheme.userBadgeFill
            : GitVisualTheme.repositoryBadgeFill
    }

    var badgeForeground: Color {
        item.kind == .user
            ? GitVisualTheme.accentBlue
            : GitVisualTheme.accentMint
    }

    var disclosureIndicatorStyle: GitDisclosureIndicatorStyle {
        GitDisclosureIndicatorStyle(
            color: GitVisualTheme.tertiaryText,
            font: .system(
                size: GitAppLayout.Row.accessoryChevronSize,
                weight: .bold
            ),
            symbol: .chevronRight
        )
    }

    var formattedStarCount: String? {
        guard let starCount = item.starCount else {
            return nil
        }

        if starCount >= GithubSearchAutocompleteConfiguration.StarCount.million {
            return L10n.searchAutocompleteStarsMillions(
                Float(starCount) / Float(GithubSearchAutocompleteConfiguration.StarCount.million)
            )
        }

        if starCount >= GithubSearchAutocompleteConfiguration.StarCount.thousand {
            return L10n.searchAutocompleteStarsThousands(
                Float(starCount) / Float(GithubSearchAutocompleteConfiguration.StarCount.thousand)
            )
        }

        return String(starCount)
    }

    var kindBadge: some View {
        GitCapsuleBadge(
            title: item.kind == .user
                ? L10n.searchAutocompleteBadgeUser
                : L10n.searchAutocompleteBadgeRepository,
            style: badgeStyle
        )
    }

    var leadingIcon: some View {
        Group {
            switch item.kind {
            case .repository:
                repositoryIcon
            case .user:
                userIcon
            }
        }
        .frame(
            width: GitAppLayout.Row.iconFrameSize,
            height: GitAppLayout.Row.iconFrameSize
        )
    }

    var mainContent: some View {
        VStack(
            alignment: .leading,
            spacing: item.kind == .repository
                ? GitAppLayout.Row.repositoryContentSpacing
                : GitAppLayout.Shared.zero
        ) {
            Text(item.title)
                .font(
                    GitVisualTheme.font(
                        size: item.kind == .repository
                            ? GitAppLayout.Row.repositoryTitleFontSize
                            : GitAppLayout.Row.titleFontSize,
                        weight: .bold
                    )
                )
                .foregroundStyle(GitVisualTheme.primaryText)
                .lineLimit(GitAppTheme.LineLimit.single)

            switch item.kind {
            case .repository:
                repositoryContent
            case .user:
                userContent
            }
        }
    }

    var repositoryContent: some View {
        VStack(alignment: .leading, spacing: GitAppLayout.Row.repositoryContentSpacing) {
            Text(item.detailText ?? item.subtitle)
                .font(GitVisualTheme.font(size: GitAppLayout.Row.subtitleFontSize))
                .foregroundStyle(GitVisualTheme.secondaryText)
                .lineLimit(GitAppTheme.LineLimit.single)

            HStack(spacing: GitAppLayout.Row.metricsSpacing) {
                if let primaryLanguage = item.primaryLanguage, !primaryLanguage.isEmpty {
                    HStack(spacing: GitAppLayout.Row.languageSpacing) {
                        Circle()
                            .fill(GithubSearchRepositoryLanguage.dotColor(for: primaryLanguage))
                            .frame(width: GitAppLayout.Row.languageDotSize, height: GitAppLayout.Row.languageDotSize)

                        Text(primaryLanguage)
                    }
                }

                if let formattedStarCount {
                    HStack(spacing: GitAppLayout.Row.starSpacing) {
                        Image(systemName: GitSymbol.star.systemName)
                            .font(.system(size: GitAppLayout.Row.starIconSize, weight: .semibold))

                        Text(formattedStarCount)
                    }
                }
            }
            .font(GitVisualTheme.font(size: GitAppLayout.Row.metadataFontSize))
            .foregroundStyle(GitVisualTheme.metricText)
        }
    }

    var repositoryIcon: some View {
        GitAsyncAvatar(
            url: item.avatarURL,
            fallbackSymbol: .command,
            style: repositoryAvatarStyle
        )
    }

    var userContent: some View {
        Text(item.subtitle)
            .font(GitVisualTheme.font(size: GitAppLayout.Row.subtitleFontSize))
            .foregroundStyle(GitVisualTheme.secondaryText)
            .lineLimit(GitAppTheme.LineLimit.single)
    }

    var userIcon: some View {
        GitAsyncAvatar(
            url: item.avatarURL,
            fallbackSymbol: .personFill,
            style: userAvatarStyle
        )
    }

    var repositoryAvatarStyle: GitAsyncAvatarStyle {
        GitAsyncAvatarStyle(
            shape: .rounded(cornerRadius: GitAppTheme.CornerRadius.small),
            surface: GitAsyncAvatarSurfaceStyle(
                backgroundColor: GitVisualTheme.searchFill,
                backgroundOpacity: GitVisualTheme.Row.avatarBackgroundOpacity,
                borderColor: GitVisualTheme.accentBlue.opacity(
                    GitVisualTheme.Row.repositoryBorderOpacity
                ),
                borderWidth: GitAppTheme.BorderWidth.emphasis
            ),
            fallback: GitAsyncAvatarFallbackStyle(
                iconColor: GitVisualTheme.accentBlue,
                iconSize: GitAppLayout.Row.avatarFallbackIconSize
            ),
            shadow: GitAsyncAvatarShadowStyle(
                color: GitVisualTheme.accentBlue.opacity(
                    GitVisualTheme.Row.repositoryShadowOpacity
                ),
                radius: GitAppLayout.Row.iconShadowRadius
            ),
            motion: GitAsyncAvatarMotionStyle(
                transitionDuration: GitVisualTheme.Motion.avatarTransitionDuration
            )
        )
    }

    var userAvatarStyle: GitAsyncAvatarStyle {
        GitAsyncAvatarStyle(
            shape: .circle,
            surface: GitAsyncAvatarSurfaceStyle(
                backgroundColor: GitVisualTheme.searchFill,
                backgroundOpacity: GitVisualTheme.Row.avatarBackgroundOpacity,
                borderColor: GitVisualTheme.accentBlue.opacity(
                    GitVisualTheme.Row.userBorderOpacity
                ),
                borderWidth: GitAppTheme.BorderWidth.emphasis
            ),
            fallback: GitAsyncAvatarFallbackStyle(
                iconColor: GitVisualTheme.accentBlue,
                iconSize: GitAppLayout.Row.avatarFallbackIconSize
            ),
            shadow: GitAsyncAvatarShadowStyle(
                color: GitVisualTheme.accentBlue.opacity(
                    GitVisualTheme.Row.userShadowOpacity
                ),
                radius: GitAppLayout.Row.iconShadowRadius
            ),
            motion: GitAsyncAvatarMotionStyle(
                transitionDuration: GitVisualTheme.Motion.avatarTransitionDuration
            )
        )
    }

    var surfaceStyle: GitSurfaceCardStyle {
        GitSurfaceCardStyle(
            shape: GitSurfaceCardShapeStyle(
                cornerRadius: GitAppTheme.CornerRadius.medium
            ),
            fill: GitSurfaceCardFillStyle(
                color: GitVisualTheme.rowFill
            ),
            border: GitSurfaceCardBorderStyle(
                color: GitVisualTheme.rowStroke,
                width: GitAppTheme.BorderWidth.regular
            ),
            shadow: GitSurfaceCardShadowStyle(
                color: GitVisualTheme.accentBlue.opacity(GitVisualTheme.Row.surfaceShadowOpacity),
                radius: GitAppLayout.Row.surfaceShadowRadius
            )
        )
    }
}
