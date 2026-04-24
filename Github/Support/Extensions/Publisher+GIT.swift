import Combine
import Foundation

extension Publisher {
    func gitFirst(
        timeout: TimeInterval = .infinity,
        scheduler: some Scheduler = DispatchQueue.main
    ) async throws -> Output {
        for try await value in self.timeout(
            .seconds(timeout),
            scheduler: scheduler
        ).values {
            return value
        }

        fatalError("Expected the publisher to emit a value or throw.")
    }
}
