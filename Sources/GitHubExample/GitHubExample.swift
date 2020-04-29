public class GitHubExampleApp {

    public enum Event {
        case initial([Repository])
    }

    let api: GitHubAPI
    var handlers: [(Event) -> Void] = []
    public init(api: GitHubAPI) {
        self.api = api
    }

    public func greeting() -> String {
        return "Hello, world"
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) {
        handlers.append(handler)
    }

    public func search(query: String) {
        api.searchRepositories(query) { repositories in
            self.handlers.forEach {
                $0(.initial(repositories))
            }
        }
    }
}

public struct Repository {
    public let id: Int
    public let fullName: String

    public init(id: Int, fullName: String) {
        self.id = id
        self.fullName = fullName
    }
}

public protocol GitHubAPI {
    func searchRepositories(_ query: String, _ callback: @escaping ([Repository]) -> Void)
}
