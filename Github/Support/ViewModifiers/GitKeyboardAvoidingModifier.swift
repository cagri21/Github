import SwiftUI

struct GitKeyboardAvoidingModifier: ViewModifier {
    let isActive: Bool
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, isActive ? keyboardHeight : 0)
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillChangeFrameNotification
                )
            ) { notification in
                updateKeyboardHeight(with: notification)
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillHideNotification
                )
            ) { notification in
                updateKeyboardHeight(with: notification)
            }
    }

    private func updateKeyboardHeight(with notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[
                UIResponder.keyboardFrameEndUserInfoKey
              ] as? CGRect,
              let duration = userInfo[
                UIResponder.keyboardAnimationDurationUserInfoKey
              ] as? Double else {
            return
        }

        let screenHeight = UIScreen.main.bounds.height
        let height = max(0, screenHeight - endFrame.origin.y)

        withAnimation(.easeOut(duration: duration)) {
            keyboardHeight = height
        }
    }
}
