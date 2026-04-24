import Foundation

struct GitSearchBarContentProps {
    let cancelTitle: String
    let leadingSymbol: GitSymbol
    let placeholder: String
    let query: String

    init(
        query: String,
        placeholder: String,
        cancelTitle: String,
        leadingSymbol: GitSymbol = .magnifyingglass
    ) {
        self.query = query
        self.placeholder = placeholder
        self.cancelTitle = cancelTitle
        self.leadingSymbol = leadingSymbol
    }
}

struct GitSearchBarProps {
    let content: GitSearchBarContentProps
    let style: GitSearchBarStyle
}
