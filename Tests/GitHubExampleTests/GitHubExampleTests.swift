import XCTest
@testable import GitHubExample

class GitHubExampleTests: XCTestCase {
    func testGreeting() {
        let app = GitHubExample()
        XCTAssertEqual(app.greeting(), "Hello, world")
    }
}
