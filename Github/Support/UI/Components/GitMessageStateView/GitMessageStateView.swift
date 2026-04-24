import SwiftUI

struct GitMessageStateView<Glyph: View, Ornament: View, ActionContent: View>: View {
    let content: GitMessageStateContent
    let style: GitMessageStateViewStyle

    private let actionContent: (() -> ActionContent)?
    private let glyph: () -> Glyph
    private let ornament: () -> Ornament

    init(
        content: GitMessageStateContent,
        style: GitMessageStateViewStyle,
        @ViewBuilder glyph: @escaping () -> Glyph,
        @ViewBuilder ornament: @escaping () -> Ornament
    ) where ActionContent == EmptyView {
        self.content = content
        self.style = style
        self.actionContent = nil
        self.glyph = glyph
        self.ornament = ornament
    }

    init(
        content: GitMessageStateContent,
        style: GitMessageStateViewStyle,
        @ViewBuilder glyph: @escaping () -> Glyph,
        @ViewBuilder ornament: @escaping () -> Ornament,
        @ViewBuilder actionContent: @escaping () -> ActionContent
    ) {
        self.content = content
        self.style = style
        self.actionContent = actionContent
        self.glyph = glyph
        self.ornament = ornament
    }

    var body: some View {
        VStack(alignment: .leading, spacing: GitSpacing.zero) {
            Text(content.eyebrow)
                .font(style.typography.eyebrowFont)
                .foregroundStyle(style.colors.eyebrowColor)
                .padding(.top, style.layout.topPadding)

            Spacer(minLength: GitSpacing.zero)

            VStack(spacing: style.layout.contentSpacing) {
                glyph()
                    .padding(.bottom, style.layout.glyphBottomPadding)

                ornament()

                Text(content.title)
                    .font(style.typography.titleFont)
                    .foregroundStyle(style.colors.titleColor)
                    .multilineTextAlignment(.center)

                Text(content.message)
                    .font(style.typography.messageFont)
                    .foregroundStyle(style.colors.messageColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(style.text.messageLineSpacing)

                if let actionContent {
                    actionContent()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, style.layout.contentBottomPadding)

            Spacer(minLength: GitSpacing.zero)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
