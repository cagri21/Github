import SwiftUI

struct GitStatusGlyph: View {
    let kind: GitStatusGlyphKind
    let color: Color
    let style: GitStatusGlyphStyle

    var body: some View {
        ZStack {
            ForEach(0 ..< style.ring.count, id: \.self) { index in
                Circle()
                    .stroke(
                        color.opacity(style.ring.baseOpacity - Double(index) * style.ring.opacityStep),
                        lineWidth: style.ring.strokeWidth
                    )
                    .frame(
                        width: style.ring.baseSize + CGFloat(index) * style.ring.sizeStep,
                        height: style.ring.baseSize + CGFloat(index) * style.ring.sizeStep
                    )
                    .blur(radius: CGFloat(index) * style.ring.blurStep)
            }

            Circle()
                .fill(color.opacity(style.glow.opacity))
                .frame(width: style.glow.size, height: style.glow.size)
                .blur(radius: style.glow.blurRadius)

            switch kind {
            case let .symbol(symbol):
                Image(systemName: symbol.systemName)
                    .font(.system(size: style.symbol.size, weight: .semibold))
                    .foregroundStyle(color.opacity(style.symbol.opacity))
                    .shadow(color: color.opacity(style.symbol.opacity), radius: style.symbol.primaryShadowRadius)
                    .shadow(
                        color: color.opacity(style.symbol.secondaryShadowOpacity),
                        radius: style.symbol.secondaryShadowRadius
                    )
            case let .loading(symbol):
                GitStatusLoadingOrbit(
                    color: color,
                    style: style.loading,
                    symbol: symbol
                )
            }
        }
        .frame(width: style.frame.size, height: style.frame.size)
    }
}
