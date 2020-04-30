public class GitHubExampleApp {

    public enum Event {
        case repositories([Repository])
        case error(Error)
    }

    var pagination: Pagination<GitHubSearchRepositoryRequest>
    let networkSession: NetworkSession
    var handlers: [(Event) -> Void] = []

    var repos: [Repository] = []

    public init(networkSession: NetworkSession) {
        self.pagination = Pagination(networkSession: networkSession)
        self.networkSession = networkSession

        pagination.subscribe { [weak self] result in
            guard let self = self else { return }
            let event: Event
            switch result {
            case .initial(let response):
                self.repos = response.items
                event = .repositories(self.repos)
            case .next(let response):
                self.repos += response.items
                event = .repositories(self.repos)
            case .error(let error):
                event = .error(error)
            }
            self.handlers.forEach {
                $0(event)
            }
        }
    }

    public func subscribe(_ handler: @escaping (Event) -> Void) {
        handlers.append(handler)
    }

    public func search(query: String) {
        let request = GitHubSearchRepositoryRequest(query: query, page: 1)
        self.pagination.initialize(request)
    }

    public func nextPage() {
        self.pagination.next()
    }
}
