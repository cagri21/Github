import Foundation

public struct SearchRequestQuery: Encodable, Sendable {
    let page: Int
    let perPage: Int
    let query: String

    public init(
        query: String,
        perPage: Int,
        page: Int = 1
    ) {
        self.page = page
        self.perPage = perPage
        self.query = query
    }

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case query = "q"
    }
}
