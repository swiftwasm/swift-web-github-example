import XCTest
@testable import GitHubExample

class GitHubExampleTests: XCTestCase {

    func testPagination() {
        struct RequestMock: GitHubAPIRequest, PaginationRequest {
            var path: String { "path/to/mock" }
            typealias Response = Int
            let page: Int
            let limit: Int

            func next(from response: Int) -> RequestMock? {
                return limit <= page ? nil : RequestMock(page: page + 1, limit: limit)
            }
        }
        class NetworkMock: NetworkSession {
            class NopTask: Task {}
            var requests: [RequestMock] = []
            var pendingCallbacks: [() -> Void] = []

            func resumeRequest() {
                pendingCallbacks.removeFirst()()
            }

            func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) -> Task where R: GitHubAPIRequest {
                assert(request is RequestMock)
                requests.append(request as! RequestMock)
                pendingCallbacks.append { callback(.success(Int(0) as! R.Response)) }
                return NopTask()
            }
        }
        let networkMock = NetworkMock()
        let pagination = Pagination<RequestMock>(networkSession: networkMock)
        var initialEvents: [Int] = []
        var nextEvents: [Int] = []
        pagination.subscribe { event in
            switch event {
            case .initial(let event): initialEvents.append(event)
            case .next(let event): nextEvents.append(event)
            case .error: fatalError("unreachable")
            }
        }

        // Request before initialize
        pagination.next()
        XCTAssertTrue(networkMock.requests.isEmpty)

        // Initialize
        pagination.initialize(RequestMock(page: 0, limit: 3))
        XCTAssertEqual(networkMock.requests.map(\.page), [0])

        // Next before request didn't finished
        pagination.next()
        XCTAssertEqual(networkMock.requests.map(\.page), [0])

        // Finished initial request and ignored next request
        networkMock.resumeRequest()
        XCTAssertEqual(initialEvents.count, 1)
        XCTAssertEqual(nextEvents.count, 0)
        XCTAssertEqual(networkMock.requests.map(\.page), [0])
        XCTAssertTrue(networkMock.pendingCallbacks.isEmpty)

        // Request twice at same time
        pagination.next()
        pagination.next()
        XCTAssertEqual(initialEvents.count, 1)
        XCTAssertEqual(nextEvents.count, 0)
        XCTAssertEqual(networkMock.requests.map(\.page), [0, 1])

        networkMock.resumeRequest()
        XCTAssertEqual(nextEvents.count, 1)
        XCTAssertEqual(networkMock.requests.map(\.page), [0, 1])
        XCTAssertTrue(networkMock.pendingCallbacks.isEmpty)

        pagination.next()
        networkMock.resumeRequest()
        // 4th request
        pagination.next()
        networkMock.resumeRequest()
        XCTAssertTrue(pagination.isFinished)
        XCTAssertEqual(networkMock.requests.map(\.page), [0, 1, 2, 3])

        // 5th request
        pagination.next()
        XCTAssertEqual(networkMock.requests.map(\.page), [0, 1, 2, 3])
    }
}
