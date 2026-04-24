import CommonData
import Foundation

func githubSearchHeaders(
    config: DataSourceConfig
) -> [String: String] {
    var headers = config.defaultHeaders
    headers["x-api-key"] = nil
    headers["Accept"] = "application/vnd.github+json"
    headers["X-GitHub-Api-Version"] = "2022-11-28"

    if let apiKey = config.apiKey?.trimmingCharacters(in: .whitespacesAndNewlines),
       !apiKey.isEmpty {
        headers["Authorization"] = "Bearer \(apiKey)"
    }

    return headers
}
