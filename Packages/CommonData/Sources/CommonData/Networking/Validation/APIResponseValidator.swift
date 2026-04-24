public enum APIResponseValidator {
    public static func validate(
        header: APIHeaderProtocol?,
        expectedStatusCode: Int = 200
    ) throws {
        guard let actualStatusCode = header?.statusCode else {
            throw APIResponseValidationError.invalidStatusCode(
                expected: expectedStatusCode,
                actual: nil
            )
        }

        guard actualStatusCode == expectedStatusCode else {
            throw APIResponseValidationError.custom(
                code: header?.messageCode ?? "unexpected_status",
                message: header?.message ?? "Unexpected API response."
            )
        }
    }
}
