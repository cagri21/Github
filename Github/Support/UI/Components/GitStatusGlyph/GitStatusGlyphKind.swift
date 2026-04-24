import Foundation

enum GitStatusGlyphKind: Equatable {
    case symbol(GitSymbol)
    case loading(GitSymbol)
}
