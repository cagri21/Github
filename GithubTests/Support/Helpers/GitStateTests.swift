@testable import Github
import Testing

@Suite("Git state helpers")
struct GitStateTests {
    @Test func exposesLoadingValueAndMessagesForEachState() {
        #expect(GitState<Int>.loading.isLoading)
        #expect(!GitState<Int>.idle(message: "Start").isLoading)
        #expect(GitState<Int>.data(42).value == 42)
        #expect(GitState<Int>.loading.value == nil)
        #expect(GitState<Int>.idle(message: "Start").message == "Start")
        #expect(GitState<Int>.empty(message: "No data").message == "No data")
        #expect(GitState<Int>.error(message: "Failed").message == "Failed")
        #expect(GitState<Int>.data(42).message == nil)
    }

    @Test func representableForwardsComputedValuesToUnderlyingState() {
        let loading = StateWrapper(gitState: GitState<String>.loading)
        let data = StateWrapper(gitState: GitState<String>.data("swift"))
        let error = StateWrapper(gitState: GitState<String>.error(message: "Failed"))

        #expect(loading.isLoading)
        #expect(data.value == "swift")
        #expect(error.message == "Failed")
    }
}

private struct StateWrapper<Value>: GitStateRepresentable {
    let gitState: GitState<Value>
}
