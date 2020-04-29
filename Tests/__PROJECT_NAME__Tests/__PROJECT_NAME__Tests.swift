import XCTest
@testable import __PROJECT_NAME__

class __PROJECT_NAME__Tests: XCTestCase {
    func testGreeting() {
        let app = __PROJECT_NAME__()
        XCTAssertEqual(app.greeting(), "Hello, world")
    }
}
