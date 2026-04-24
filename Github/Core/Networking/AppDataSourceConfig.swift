import CommonData
import Foundation

struct AppDataSourceConfig: DataSourceConfig {
    let baseURL: URL
    let apiKey: String?
    let contentType: String
    let userAgent: String?
    let acceptLanguage: String?

    init(
        bundle: Bundle = .main
    ) {
        let bundleName = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        let version = bundle.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String

        baseURL = bundle.requiredURL(for: .baseURL)
        apiKey = bundle.optionalString(for: .apiKey)
        contentType = bundle.optionalString(for: .contentType) ?? "application/json"
        acceptLanguage = bundle.optionalString(for: .acceptLanguage) ?? Locale.preferredLanguages.first
        userAgent = [bundleName, version]
            .compactMap { $0 }
            .joined(separator: "/")
    }
}
