import GitHubExample
import JavaScriptKit

class GitHubViewController {

    let view: GitHubView

    init(
        view: GitHubView,
        app: GitHubExampleApp
    ) {
        self.view = view

        view.searchForm.addEventListener("submit") { event in
            event.preventDefault()
            let query = view.queryString()
            app.search(query: query)
        }

        app.subscribe { (event) in
            switch event {
            case .initial(let repos):
                view.setRepositories(repos)
            case .error(let error):
                alert("\(error)")
            }
        }
    }
}
