import SwiftUI

enum GithubSearchAutocompleteStatusModel: Equatable {
    case empty
    case error
    case hint
    case loading

    var color: Color {
        switch self {
        case .empty, .hint, .loading:
            GitVisualTheme.accentCyan
        case .error:
            GitVisualTheme.danger
        }
    }

    var symbol: GitSymbol {
        switch self {
        case .empty, .hint:
            .magnifyingglass
        case .error:
            .errorOctagon
        case .loading:
            .sparkle
        }
    }

    var glyphKind: GitStatusGlyphKind {
        switch self {
        case .loading:
            .loading(symbol)
        case .empty, .error, .hint:
            .symbol(symbol)
        }
    }
}

struct GithubSearchAutocompleteStatusView: View {
    let model: GithubSearchAutocompleteStatusModel
    let eyebrow: String
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?

    init(
        model: GithubSearchAutocompleteStatusModel,
        eyebrow: String,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.model = model
        self.eyebrow = eyebrow
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
    }

    var body: some View {
        Group {
            if let buttonTitle, let action {
                GitMessageStateView(
                    content: content,
                    style: style,
                    glyph: { glyph },
                    ornament: { GithubSearchAutocompleteSparkleView() },
                    actionContent: {
                        GitGradientCapsuleButton(
                            title: buttonTitle,
                            style: buttonStyle,
                            action: action
                        )
                        .padding(.top, GitAppLayout.State.buttonTopPadding)
                    }
                )
            } else {
                GitMessageStateView(
                    content: content,
                    style: style,
                    glyph: { glyph },
                    ornament: { GithubSearchAutocompleteSparkleView() }
                )
            }
        }
    }
}

private struct GithubSearchAutocompleteSparkleView: View {
    var body: some View {
        Image(systemName: GitSymbol.sparkle.systemName)
            .font(.system(size: GitAppLayout.Background.sparkleSize, weight: .bold))
            .foregroundStyle(GitVisualTheme.accentPink)
            .shadow(
                color: GitVisualTheme.accentPink,
                radius: GitAppLayout.Background.starGlowRadius
            )
    }
}

private extension GithubSearchAutocompleteStatusView {
    var content: GitMessageStateContent {
        GitMessageStateContent(
            eyebrow: eyebrow,
            title: title,
            message: message
        )
    }

    var buttonStyle: GitGradientCapsuleButtonStyle {
        GitGradientCapsuleButtonStyle(
            typography: GitGradientCapsuleButtonTypographyStyle(
                font: GitVisualTheme.font(
                    size: GitAppLayout.State.retryFontSize,
                    weight: .bold
                ),
                foregroundColor: GitVisualTheme.primaryText
            ),
            layout: GitGradientCapsuleButtonLayoutStyle(
                width: GitAppLayout.State.buttonWidth,
                height: GitAppLayout.State.buttonHeight
            ),
            fill: GitGradientCapsuleButtonFillStyle(
                fillStyle: AnyShapeStyle(GitVisualTheme.retryGradient)
            ),
            border: GitGradientCapsuleButtonBorderStyle(
                color: GitVisualTheme.accentPurple.opacity(GitVisualTheme.Action.retryBorderOpacity),
                width: GitAppTheme.BorderWidth.regular
            ),
            shadow: GitGradientCapsuleButtonShadowStyle(
                color: GitVisualTheme.accentPurple.opacity(GitVisualTheme.Action.retryShadowOpacity),
                radius: GitAppLayout.State.retryShadowRadius
            )
        )
    }

    var glyph: some View {
        GitStatusGlyph(
            kind: model.glyphKind,
            color: model.color,
            style: glyphStyle
        )
    }

    var glyphStyle: GitStatusGlyphStyle {
        GitStatusGlyphStyle(
            ring: GitStatusGlyphRingStyle(
                baseSize: GitAppLayout.State.ringBaseSize,
                baseOpacity: GitVisualTheme.StateGlyph.ringBaseOpacity,
                blurStep: GitAppLayout.State.ringBlurStep,
                count: GitAppLayout.State.ringCount,
                opacityStep: GitVisualTheme.StateGlyph.ringOpacityStep,
                sizeStep: GitAppLayout.State.ringSizeStep,
                strokeWidth: GitAppLayout.State.ringStrokeWidth
            ),
            glow: GitStatusGlyphGlowStyle(
                opacity: GitVisualTheme.StateGlyph.glowOpacity,
                size: GitAppLayout.State.statusGlowSize,
                blurRadius: GitAppLayout.State.glowBlurRadius
            ),
            symbol: GitStatusGlyphSymbolStyle(
                size: GitAppLayout.Background.statusSymbolSize,
                opacity: GitVisualTheme.StateGlyph.symbolOpacity,
                primaryShadowRadius: GitAppLayout.State.primaryShadowRadius,
                secondaryShadowOpacity: GitVisualTheme.StateGlyph.secondaryShadowOpacity,
                secondaryShadowRadius: GitAppLayout.State.secondaryShadowRadius
            ),
            frame: GitStatusGlyphFrameStyle(
                size: GitAppLayout.State.glyphSize
            ),
            loading: GitStatusGlyphLoadingStyle(
                orbit: GitStatusLoadingOrbitStyle(
                    size: GitAppLayout.Background.loadingOrbitSize,
                    lineWidth: GitAppLayout.Background.loadingOrbitCircleLineWidth,
                    rotationDuration: GitVisualTheme.Motion.loadingOrbitRotationDuration,
                    strokeOpacity: GitVisualTheme.StateGlyph.loadingOrbitStrokeOpacity
                ),
                bar: GitStatusLoadingBarStyle(
                    width: GitAppLayout.Background.loadingOrbitBarWidth,
                    height: GitAppLayout.Background.loadingOrbitBarHeight,
                    offsetX: GitAppLayout.Background.loadingOrbitBarOffsetX,
                    startOpacity: GitVisualTheme.StateGlyph.loadingOrbitStartOpacity,
                    accentOpacity: GitVisualTheme.StateGlyph.loadingAccentOpacity,
                    accentColor: GitVisualTheme.accentPurple
                ),
                glyph: GitStatusLoadingGlyphStyle(
                    size: GitAppLayout.Background.loadingOrbitGlyphSize,
                    opacity: GitVisualTheme.StateGlyph.loadingGlyphOpacity,
                    shadowRadius: GitAppLayout.Background.loadingOrbitGlyphShadowRadius
                )
            )
        )
    }

    var style: GitMessageStateViewStyle {
        GitMessageStateViewStyle(
            typography: GitMessageStateTypographyStyle(
                eyebrowFont: GitVisualTheme.font(
                    size: GitAppLayout.State.eyebrowFontSize
                ),
                titleFont: GitVisualTheme.font(
                    size: GitAppLayout.State.titleFontSize,
                    weight: .bold
                ),
                messageFont: GitVisualTheme.font(
                    size: GitAppLayout.State.messageFontSize
                )
            ),
            colors: GitMessageStateColorStyle(
                eyebrowColor: GitVisualTheme.secondaryText,
                titleColor: GitVisualTheme.primaryText,
                messageColor: GitVisualTheme.secondaryText
            ),
            layout: GitMessageStateLayoutStyle(
                topPadding: GitAppLayout.State.eyebrowTopPadding,
                contentSpacing: GitAppLayout.State.contentSpacing,
                glyphBottomPadding: GitAppLayout.State.glyphBottomPadding,
                contentBottomPadding: GitAppLayout.State.contentBottomPadding
            ),
            text: GitMessageStateTextStyle(
                messageLineSpacing: GitAppLayout.Text.lineSpacing
            )
        )
    }
}
