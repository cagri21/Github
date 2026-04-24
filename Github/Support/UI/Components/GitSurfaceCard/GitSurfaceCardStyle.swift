import SwiftUI

struct GitSurfaceCardShapeStyle {
    let cornerRadius: CGFloat
}

struct GitSurfaceCardFillStyle {
    let color: Color
}

struct GitSurfaceCardBorderStyle {
    let color: Color
    let width: CGFloat
}

struct GitSurfaceCardShadowStyle {
    let color: Color
    let radius: CGFloat
}

struct GitSurfaceCardStyle {
    let shape: GitSurfaceCardShapeStyle
    let fill: GitSurfaceCardFillStyle
    let border: GitSurfaceCardBorderStyle
    let shadow: GitSurfaceCardShadowStyle
}
