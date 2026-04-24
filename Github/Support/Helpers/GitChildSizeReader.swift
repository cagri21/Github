import SwiftUI

struct GitChildSizeReader<Content: View>: View {
    @Binding private var size: CGSize
    private let content: () -> Content

    init(
        size: Binding<CGSize>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _size = size
        self.content = content
    }

    var body: some View {
        content()
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: GitSizePreferenceKey.self,
                        value: proxy.size
                    )
                }
            )
            .onPreferenceChange(GitSizePreferenceKey.self) { size in
                self.size = size
            }
    }
}

private struct GitSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(
        value: inout CGSize,
        nextValue: () -> CGSize
    ) {
        value = nextValue()
    }
}
