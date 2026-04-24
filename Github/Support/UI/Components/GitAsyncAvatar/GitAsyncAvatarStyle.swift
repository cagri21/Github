import SwiftUI

enum GitAsyncAvatarShape {
    case circle
    case rounded(cornerRadius: CGFloat)
}

struct GitAsyncAvatarSurfaceStyle {
    let backgroundColor: Color
    let backgroundOpacity: Double
    let borderColor: Color
    let borderWidth: CGFloat
}

struct GitAsyncAvatarFallbackStyle {
    let iconColor: Color
    let iconSize: CGFloat
}

struct GitAsyncAvatarShadowStyle {
    let color: Color
    let radius: CGFloat
}

struct GitAsyncAvatarMotionStyle {
    let transitionDuration: Double
}

struct GitAsyncAvatarStyle {
    let shape: GitAsyncAvatarShape
    let surface: GitAsyncAvatarSurfaceStyle
    let fallback: GitAsyncAvatarFallbackStyle
    let shadow: GitAsyncAvatarShadowStyle
    let motion: GitAsyncAvatarMotionStyle
}
