import SwiftUI

enum GitAppTheme {
    enum Angle {
        static let fullRotation = 360.0
    }

    enum Typography {
        static func font(
            size: CGFloat,
            weight: SwiftUI.Font.Weight = .regular,
            design: SwiftUI.Font.Design = .default
        ) -> SwiftUI.Font {
            SwiftUI.Font.system(size: size, weight: weight, design: design)
        }
    }

    enum CornerRadius {
        static let small: CGFloat = 6
        static let medium: CGFloat = 9
    }

    enum LineLimit {
        static let single = 1
    }

    enum Opacity {
        static let divider = 0.20
    }

    enum BorderWidth {
        static let regular: CGFloat = 1
        static let emphasis: CGFloat = 1.2
    }

    enum Ratio {
        static let half: CGFloat = 0.5
    }
}
