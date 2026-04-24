import SwiftUI

struct GitStatusGlyphRingStyle {
    let baseSize: CGFloat
    let baseOpacity: Double
    let blurStep: CGFloat
    let count: Int
    let opacityStep: Double
    let sizeStep: CGFloat
    let strokeWidth: CGFloat
}

struct GitStatusGlyphGlowStyle {
    let opacity: Double
    let size: CGFloat
    let blurRadius: CGFloat
}

struct GitStatusGlyphSymbolStyle {
    let size: CGFloat
    let opacity: Double
    let primaryShadowRadius: CGFloat
    let secondaryShadowOpacity: Double
    let secondaryShadowRadius: CGFloat
}

struct GitStatusGlyphFrameStyle {
    let size: CGFloat
}

struct GitStatusLoadingOrbitStyle {
    let size: CGFloat
    let lineWidth: CGFloat
    let rotationDuration: Double
    let strokeOpacity: Double
}

struct GitStatusLoadingBarStyle {
    let width: CGFloat
    let height: CGFloat
    let offsetX: CGFloat
    let startOpacity: Double
    let accentOpacity: Double
    let accentColor: Color
}

struct GitStatusLoadingGlyphStyle {
    let size: CGFloat
    let opacity: Double
    let shadowRadius: CGFloat
}

struct GitStatusGlyphLoadingStyle {
    let orbit: GitStatusLoadingOrbitStyle
    let bar: GitStatusLoadingBarStyle
    let glyph: GitStatusLoadingGlyphStyle
}

struct GitStatusGlyphStyle {
    let ring: GitStatusGlyphRingStyle
    let glow: GitStatusGlyphGlowStyle
    let symbol: GitStatusGlyphSymbolStyle
    let frame: GitStatusGlyphFrameStyle
    let loading: GitStatusGlyphLoadingStyle
}
