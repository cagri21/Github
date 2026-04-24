import SwiftUI

struct GitDisclosureIndicatorStyle {
    let color: Color
    let font: SwiftUI.Font
    let symbol: GitSymbol
}

struct GitDisclosureIndicator: View {
    let style: GitDisclosureIndicatorStyle

    var body: some View {
        Image(systemName: style.symbol.systemName)
            .font(style.font)
            .foregroundStyle(style.color)
    }
}
