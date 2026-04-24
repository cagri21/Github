import Foundation

enum GitSymbol: String, Equatable, Sendable {
    case chevronRight = "chevron.right"
    case clearCircleFill = "xmark.circle.fill"
    case command
    case errorOctagon = "exclamationmark.octagon"
    case magnifyingglass
    case personFill = "person.fill"
    case sparkle
    case star

    var systemName: String {
        rawValue
    }
}
