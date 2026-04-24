import Foundation

extension String {
    static var gitEmpty: String {
        ""
    }

    var gitIsBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func gitRemovingTrailingSpace() -> String {
        last == " " ? String(dropLast()) : self
    }

    func gitRemovingLeadingSpace() -> String {
        first == " " ? String(dropFirst()) : self
    }

    func gitRestrictingMultipleSpaces() -> String {
        var result = self

        while result.contains("  ") {
            result = result.replacingOccurrences(of: "  ", with: " ")
        }

        return result
    }

    func gitNumbersOnly() -> String {
        replacingOccurrences(
            of: "[^0-9]",
            with: "",
            options: .regularExpression
        )
    }

    func gitIsValidEmail() -> Bool {
        guard !isEmpty else { return false }

        let regex =
            "(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|" +
            "\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|" +
            "\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@" +
            "(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+" +
            "[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[" +
            "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}" +
            "(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|" +
            "[a-zA-Z0-9-]*[a-zA-Z0-9]:" +
            "(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|" +
            "\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    var gitHTMLToPlainText: String {
        guard let data = data(using: .utf8) else { return self }

        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        }

        return self
    }

    var gitLocalized: String {
        NSLocalizedString(self, comment: "")
    }

    func gitLocalized(
        comment: String,
        tableName: String? = nil,
        bundle: Bundle = .main,
        value: String = ""
    ) -> String {
        NSLocalizedString(
            self,
            tableName: tableName,
            bundle: bundle,
            value: value,
            comment: comment
        )
    }

    func gitTurkishDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")

        if contains(".") {
            return self
        }

        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: self) else {
            return self
        }

        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    func gitParseDoubleAmount() -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal
        return formatter.number(from: self)?.doubleValue ?? 0
    }
}

extension Optional where Wrapped == String {
    var gitTrimmedNonEmpty: String? {
        guard let trimmed = self?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }

        return trimmed
    }
}
