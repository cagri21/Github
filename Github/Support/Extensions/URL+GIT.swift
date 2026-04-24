import Foundation

extension URL {
    init?(gitString: String?) {
        guard let gitString else { return nil }
        self.init(string: gitString)
    }

    func gitAppending(queryItem: URLQueryItem) -> URL? {
        guard var components = URLComponents(
            url: self,
            resolvingAgainstBaseURL: false
        ) else {
            return nil
        }

        if components.queryItems != nil {
            components.queryItems?.append(queryItem)
        } else {
            components.queryItems = [queryItem]
        }

        return components.url
    }

    func gitAppending(
        name: String,
        value: String
    ) -> URL? {
        gitAppending(
            queryItem: URLQueryItem(
                name: name,
                value: value
            )
        )
    }

    var gitQueryParameters: [String: String]? {
        guard let components = URLComponents(
            url: self,
            resolvingAgainstBaseURL: true
        ),
        let queryItems = components.queryItems else {
            return nil
        }

        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
