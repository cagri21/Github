extension Collection {
    subscript(gitSafe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
