import UIKit

extension UIApplication {
    static let gitAppVersion: String = if let version = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleShortVersionString"
    ) as? String {
        version
    } else {
        ""
    }

    static let gitAppBuild: String = if let build = Bundle.main.object(
        forInfoDictionaryKey: kCFBundleVersionKey as String
    ) as? String {
        build
    } else {
        ""
    }

    func gitShare(items: [Any]) {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )

        keyWindowInConnectedScenes?.rootViewController?.present(
            controller,
            animated: true
        )
    }

    func hideKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    var keyWindowInConnectedScenes: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
