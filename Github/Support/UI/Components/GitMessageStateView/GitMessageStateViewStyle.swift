import SwiftUI

struct GitMessageStateTypographyStyle {
    let eyebrowFont: SwiftUI.Font
    let titleFont: SwiftUI.Font
    let messageFont: SwiftUI.Font
}

struct GitMessageStateColorStyle {
    let eyebrowColor: Color
    let titleColor: Color
    let messageColor: Color
}

struct GitMessageStateLayoutStyle {
    let topPadding: CGFloat
    let contentSpacing: CGFloat
    let glyphBottomPadding: CGFloat
    let contentBottomPadding: CGFloat
}

struct GitMessageStateTextStyle {
    let messageLineSpacing: CGFloat
}

struct GitMessageStateViewStyle {
    let typography: GitMessageStateTypographyStyle
    let colors: GitMessageStateColorStyle
    let layout: GitMessageStateLayoutStyle
    let text: GitMessageStateTextStyle
}
