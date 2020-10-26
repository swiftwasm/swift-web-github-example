public protocol Task: AnyObject {}
public protocol NetworkSession {
    func get<R: GitHubAPIRequest>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) -> Task
}

public protocol GitHubAPIRequest {
    associatedtype Response: Decodable
    var baseURL: String { get }
    var path: String { get }
    var queryParameters: [String: String] { get }
}

extension GitHubAPIRequest {
    public var baseURL: String {
        "https://api.github.com/"
    }
    public var queryParameters: [String: String] { return [:] }
}

public struct GitHubSearchRepositoryRequest: GitHubAPIRequest {
    public struct Response: Codable {
        let items: [Repository]
        public init(items: [Repository]) {
            self.items = items
        }
    }

    public var path: String { "search/repositories" }
    public let queryParameters: [String: String]

    let query: String
    let page: Int

    public init(query: String, page: Int) {
        self.queryParameters = ["q": query, "page": page.description]
        self.query = query
        self.page = page
    }
}

extension GitHubSearchRepositoryRequest: PaginationRequest {
    func next(from response: Response) -> GitHubSearchRepositoryRequest? {
        return response.items.isEmpty ? nil : GitHubSearchRepositoryRequest(query: query, page: page + 1)
    }
}
