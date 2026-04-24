import UIKit

extension UIWindow {
    override open func motionEnded(
        _ motion: UIEvent.EventSubtype,
        with event: UIEvent?
    ) {
        if motion == .motionShake {
            UIDevice.gitPostShakeNotification()
        }

        super.motionEnded(
            motion,
            with: event
        )
    }
}
