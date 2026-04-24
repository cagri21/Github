import Foundation

extension NumberFormatter {
    static func gitCurrencyString(
        amount: Double,
        currency: String?,
        locale: Locale = Locale(identifier: "tr_TR")
    ) -> String {
        guard let currency else { return "-" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.locale = locale

        guard let formattedAmount = formatter.string(
            from: NSNumber(value: amount)
        ) else {
            return "-"
        }

        return "\(formattedAmount) \(currency)"
    }
}
