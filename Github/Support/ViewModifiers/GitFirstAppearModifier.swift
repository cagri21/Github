import SwiftUI

private final class GitAppearGate: ObservableObject {
    var fired = false
}

struct GitFirstAppearModifier: ViewModifier {
    let perform: () -> Void
    let resetOnDisappear: Bool

    @StateObject private var gate = GitAppearGate()

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !gate.fired else { return }
                gate.fired = true
                perform()
            }
            .onDisappear {
                if resetOnDisappear {
                    gate.fired = false
                }
            }
    }
}
