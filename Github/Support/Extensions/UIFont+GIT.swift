import SwiftUI
import UIKit

extension UIFont {
    func gitBold() -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }

        return UIFont(
            descriptor: descriptor,
            size: pointSize
        )
    }
}
