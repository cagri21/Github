import SwiftUI

struct GitStatusLoadingOrbit: View {
    let color: Color
    let style: GitStatusGlyphLoadingStyle
    let symbol: GitSymbol

    var body: some View {
        TimelineView(.animation) { timeline in
            let angle = timeline.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: style.orbit.rotationDuration)
                / style.orbit.rotationDuration
                * GitAppTheme.Angle.fullRotation

            ZStack {
                Circle()
                    .stroke(color.opacity(style.orbit.strokeOpacity), lineWidth: style.orbit.lineWidth)
                    .frame(width: style.orbit.size, height: style.orbit.size)

                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(style.bar.startOpacity),
                                style.bar.accentColor.opacity(style.bar.accentOpacity)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: style.bar.width, height: style.bar.height)
                    .offset(x: style.bar.offsetX)
                    .rotationEffect(.degrees(angle))

                Image(systemName: symbol.systemName)
                    .font(.system(size: style.glyph.size, weight: .semibold))
                    .foregroundStyle(color.opacity(style.glyph.opacity))
                    .shadow(color: color.opacity(style.glyph.opacity), radius: style.glyph.shadowRadius)
            }
        }
    }
}
