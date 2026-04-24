import SwiftUI

struct GitBlurredSheetModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var item: Item?
    let blurRadius: CGFloat
    let overlayColor: Color
    let sheetContent: (Item) -> SheetContent

    func body(content: Content) -> some View {
        content
            .blur(radius: item == nil ? 0 : blurRadius)
            .overlay {
                if item != nil {
                    overlayColor
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: item != nil)
                }
            }
            .sheet(item: $item) { value in
                sheetContent(value)
            }
    }
}
