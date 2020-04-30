import GitHubExample
import JavaScriptKit

class GitHubViewController {

    let view: GitHubView
    let observer: WebIntersectionObserver

    init(
        view: GitHubView,
        app: GitHubExampleApp
    ) {
        self.view = view
        self.observer = WebIntersectionObserver { entries in
            guard let entry = entries.first, entry.isIntersecting else {
                return
            }
            app.nextPage()
        }

        self.observer.observe(view.loadMoreTag)

        view.searchForm.addEventListener("submit") { event in
            event.preventDefault()
            let query = view.queryString()
            app.search(query: query)
        }

        app.subscribe { (event) in
            switch event {
            case .repositories(let repos):
                view.setRepositories(repos)
            case .error(let error):
                alert("\(error)")
            }
        }

        // Search default query
        app.search(query: view.queryString())
    }
}
