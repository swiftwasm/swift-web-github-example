public protocol SessionType {
    func get<R: GitHubAPIRequest>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void)
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

    public init(query: String) {
        queryParameters = ["q": query]
    }
}
