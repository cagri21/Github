import SwiftUI

struct GitDoneToolbarModifier: ViewModifier {
    let isActive: Bool
    let buttonTitle: String
    let perform: (() -> Void)?

    func body(content: Content) -> some View {
        content.toolbar {
            if isActive {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(buttonTitle) {
                        UIApplication.shared.hideKeyboard()
                        perform?()
                    }
                }
            }
        }
    }
}
