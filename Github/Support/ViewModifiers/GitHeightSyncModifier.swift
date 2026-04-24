import SwiftUI

struct GitHeightSyncModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: GitHeightPreferenceKey.self,
                        value: geo.size.height
                    )
                }
            )
            .onPreferenceChange(GitHeightPreferenceKey.self) { value in
                if value > 0 {
                    height = value
                }
            }
    }
}

private struct GitHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = max(value, nextValue())
    }
}
