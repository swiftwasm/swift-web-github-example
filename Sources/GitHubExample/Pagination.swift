protocol PaginationRequest: GitHubAPIRequest {
    func next(from response: Response) -> Self?
}

class Pagination<R: PaginationRequest> {

    enum Event {
        case initial(R.Response)
        case next(R.Response)
        case error(Error)
    }

    private(set) var isInitial = true
    private(set) var isLoading = false
    private(set) var isFinished = false

    private var currentRequest: R?
    private let networkSession: NetworkSession
    private var subscribers: [(Event) -> Void] = []
    private var task: Task?

    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }

    func subscribe(_ subscriber: @escaping (Event) -> Void) {
        subscribers.append(subscriber)
    }

    private func notify(_ event: Event) {
        subscribers.forEach { $0(event) }
    }

    func initialize(_ request: R) {
        currentRequest = request
        isInitial = true
        isFinished = false
        next()
    }

    func next() {
        guard let currentRequest = currentRequest, !isLoading && !isFinished else {
            return
        }
        isLoading = true
        task = networkSession.get(currentRequest) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.isInitial {
                    self.isInitial = false
                    self.notify(.initial(response))
                } else {
                    self.notify(.next(response))
                }
                self.isLoading = false
                guard let nextRequest = currentRequest.next(from: response) else {
                    self.isFinished = true
                    return
                }
                self.currentRequest = nextRequest
            case .failure(let error):
                self.notify(.error(error))
            }
        }
    }
}
