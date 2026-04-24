import CommonData
import Foundation

extension Request where Response == GithubRepositorySearchResponseEntity, Body == Never {
    static func searchRepositories(
        _ requestQuery: SearchRequestQuery,
        config: DataSourceConfig
    ) -> Self {
        Request(
            baseURL: config.baseURL,
            path: "/search/repositories",
            headers: githubSearchHeaders(config: config),
            query: requestQuery
        )
    }
}
