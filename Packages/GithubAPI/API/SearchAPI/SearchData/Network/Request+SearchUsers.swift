import CommonData
import Foundation

extension Request where Response == GithubUserSearchResponseEntity, Body == Never {
    static func searchUsers(
        _ requestQuery: SearchRequestQuery,
        config: DataSourceConfig
    ) -> Self {
        Request(
            baseURL: config.baseURL,
            path: "/search/users",
            headers: githubSearchHeaders(config: config),
            query: requestQuery
        )
    }
}
