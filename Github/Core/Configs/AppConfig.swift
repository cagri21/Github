import Foundation

enum GitEnvironment: String {
    case gitDev = "GitDev"
    case gitQA = "GitQA"
    case gitProd = "GitProd"
}

enum AppConfigKey: String {
    case appName = "APP_NAME"
    case appBundleIdentifier = "APP_BUNDLE_IDENTIFIER"
    case environment = "GIT_ENVIRONMENT"
    case baseURL = "GIT_BASE_URL"
    case apiKey = "GIT_API_KEY"
    case acceptLanguage = "GIT_ACCEPT_LANGUAGE"
    case contentType = "GIT_CONTENT_TYPE"
    case shortVersion = "CFBundleShortVersionString"
}

struct AppConfig {
    let appName: String
    let bundleIdentifier: String
    let environment: GitEnvironment
    let dataSourceConfig: AppDataSourceConfig

    init(bundle: Bundle = .main) {
        appName = bundle.requiredString(for: .appName)
        bundleIdentifier = bundle.requiredString(for: .appBundleIdentifier)
        environment = GitEnvironment(
            rawValue: bundle.requiredString(for: .environment)
        ) ?? .gitDev
        dataSourceConfig = AppDataSourceConfig(bundle: bundle)
    }
}

extension Bundle {
    func requiredString(for key: AppConfigKey) -> String {
        guard let value = infoDictionary?[key.rawValue] as? String else {
            preconditionFailure("Missing config value for \(key.rawValue)")
        }

        return value
    }

    func optionalString(for key: AppConfigKey) -> String? {
        infoDictionary?[key.rawValue] as? String
    }

    func requiredURL(for key: AppConfigKey) -> URL {
        guard let value = infoDictionary?[key.rawValue] as? String,
              let url = URL(string: value) else {
            preconditionFailure("Missing or invalid URL for \(key.rawValue)")
        }

        return url
    }
}
