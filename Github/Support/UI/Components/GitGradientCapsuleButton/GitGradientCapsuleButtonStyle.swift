import SwiftUI

struct GitGradientCapsuleButtonTypographyStyle {
    let font: SwiftUI.Font
    let foregroundColor: Color
}

struct GitGradientCapsuleButtonLayoutStyle {
    let width: CGFloat
    let height: CGFloat
}

struct GitGradientCapsuleButtonFillStyle {
    let fillStyle: AnyShapeStyle
}

struct GitGradientCapsuleButtonBorderStyle {
    let color: Color
    let width: CGFloat
}

struct GitGradientCapsuleButtonShadowStyle {
    let color: Color
    let radius: CGFloat
}

struct GitGradientCapsuleButtonStyle {
    let typography: GitGradientCapsuleButtonTypographyStyle
    let layout: GitGradientCapsuleButtonLayoutStyle
    let fill: GitGradientCapsuleButtonFillStyle
    let border: GitGradientCapsuleButtonBorderStyle
    let shadow: GitGradientCapsuleButtonShadowStyle
}
