import CoreGraphics

enum GitSpacing {
    enum Multiplier {
        static let divider = 6
    }

    static let zero: CGFloat = 0
    static let hairline: CGFloat = 1
    static let xxxSmall: CGFloat = 2
    static let xxSmall: CGFloat = 4
    static let xSmall: CGFloat = 6
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let mediumPlus: CGFloat = 14
    static let large: CGFloat = 16
    static let xLarge: CGFloat = 20
    static let xxLarge: CGFloat = 24

    static func base(times factor: Int = 1) -> CGFloat {
        CGFloat(factor) * xxSmall
    }
}
