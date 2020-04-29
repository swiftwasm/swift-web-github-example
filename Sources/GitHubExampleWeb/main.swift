import GitHubExample
import JavaScriptKit

class View {
    init(
        form: JSObjectRef,
        app: GitHubExampleApp
    ) {
        _ = form.addEventListener!("submit", JSValue.function { args in
            let event = args[0].object!
            _ = event.preventDefault!()
            let query = form.get("query").object!.get("value").string!
            app.search(query: query)
            return .undefined
        })

        app.subscribe { (event) in
            switch event {
            case .initial(let repos):
                self.renderRepositories(repos)
            }
        }
    }

    func renderRepositories(_ repos: [Repository]) {
        let document = JSObjectRef.global.document.object!
        let ul = document.getElementById!("github-repository-list").object!
        let innerHtml = repos.map {
            "<li>\($0.fullName)</li>"
        }.joined()
        ul.innerHTML = .string(innerHtml)
    }
}

let document = JSObjectRef.global.document.object!
let githubSearchForm = document.getElementById!("github-search-form").object!

let app = GitHubExampleApp(api: GitHubAPIImpl())
let view = View(form: githubSearchForm, app: app)
