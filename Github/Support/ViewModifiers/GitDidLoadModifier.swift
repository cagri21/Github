import SwiftUI

struct GitDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didLoad else { return }
            didLoad = true
            action?()
        }
    }
}
