import Foundation

extension Date {
    func gitIsEqual(
        to other: Date,
        comparing component: Calendar.Component,
        in calendar: Calendar = .current
    ) -> Bool {
        calendar.component(component, from: self) ==
            calendar.component(component, from: other)
    }

    func gitFormatted(
        locale: Locale = .current,
        style: Date.FormatStyle = .dateTime
            .day(.twoDigits)
            .month(.twoDigits)
            .year(.defaultDigits)
    ) -> String {
        formatted(style.locale(locale))
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    static func gitFullDateWithTime(
        locale: Locale = .current
    ) -> Self {
        .dateTime
            .day()
            .month(.wide)
            .year()
            .hour()
            .minute()
            .locale(locale)
    }
}
