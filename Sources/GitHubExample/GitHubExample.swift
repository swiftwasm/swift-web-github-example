public class GitHubExampleApp {

    public enum Event {
        case initial([Repository])
        case error(Error)
    }

    let api: SessionType
    var handlers: [(Event) -> Void] = []
    public init(api: SessionType) {
        self.api = api
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) {
        handlers.append(handler)
    }

    public func search(query: String) {
        let request = GitHubSearchRepositoryRequest(query: query)
        api.get(request) { result in
            let event: Event
            switch result {
            case .success(let response):
                event = .initial(response.items)
            case .failure(let error):
                event = .error(error)
            }
            self.handlers.forEach {
                $0(event)
            }
        }
    }
}

public struct Repository: Codable {
    public let id: Int
    public let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
    }

    public init(id: Int, fullName: String) {
        self.id = id
        self.fullName = fullName
    }
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
    }
    
    public var path: String { "search/repositories" }
    public let queryParameters: [String : String]
    
    public init(query: String) {
        queryParameters = ["q": query]
    }
}


public protocol SessionType {
    func get<R: GitHubAPIRequest>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void)
}
