public class GitHubExampleApp {

    public enum Event {
        case initial([Repository])
        case error(Error)
    }

    let networkSession: NetworkSession
    var handlers: [(Event) -> Void] = []
    public init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) {
        handlers.append(handler)
    }

    public func search(query: String) {
        let request = GitHubSearchRepositoryRequest(query: query)
        networkSession.get(request) { result in
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
