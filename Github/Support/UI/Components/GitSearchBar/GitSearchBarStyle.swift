import SwiftUI

struct GitSearchBarTypographyStyle {
    let textFont: SwiftUI.Font
    let cancelFont: SwiftUI.Font
}

struct GitSearchBarColorStyle {
    let iconColor: Color
    let textColor: Color
    let placeholderColor: Color
    let tintColor: Color
    let clearIconColor: Color
    let cancelColor: Color
}

struct GitSearchBarLayoutStyle {
    let fieldSpacing: CGFloat
    let stackSpacing: CGFloat
    let horizontalPadding: CGFloat
    let fieldHeight: CGFloat
}

struct GitSearchBarIconStyle {
    let iconSize: CGFloat
    let clearIconSize: CGFloat
}

struct GitSearchBarStyle {
    let typography: GitSearchBarTypographyStyle
    let colors: GitSearchBarColorStyle
    let layout: GitSearchBarLayoutStyle
    let icons: GitSearchBarIconStyle
    let surfaceStyle: GitSurfaceCardStyle
}
