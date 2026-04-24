import SwiftUI

struct GitDismissKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.hideKeyboard()
            },
            including: .subviews
        )
    }
}
