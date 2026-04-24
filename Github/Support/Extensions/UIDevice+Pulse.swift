import UIKit

extension UIDevice {
    static let gitShowPulse = Notification.Name(rawValue: "gitShowPulse")

    private static var lastGitShakeNotificationDate = Date.distantPast

    static func gitPostShakeNotification() {
        let now = Date()
        guard now.timeIntervalSince(lastGitShakeNotificationDate) > 0.6 else {
            return
        }

        lastGitShakeNotificationDate = now
        NotificationCenter.default.post(
            name: gitShowPulse,
            object: nil
        )
    }
}
