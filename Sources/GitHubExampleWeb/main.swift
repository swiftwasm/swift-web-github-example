import GitHubExample
import JavaScriptKit

let document = WebDocument(JSObjectRef.global.document.object!)

let app = GitHubExampleApp(api: WebFetchSession())
let view = GitHubView(
    searchForm: document.getElementById("github-search-form"),
    repositoryList: document.getElementById("github-repository-list")
)

let viewController = GitHubViewController(view: view, app: app)
