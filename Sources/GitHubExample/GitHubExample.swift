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
