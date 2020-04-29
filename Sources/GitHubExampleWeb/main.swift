import GitHubExample
import JavaScriptKit

let document = WebDocument(JSObjectRef.global.document.object!)
#if DEBUG
let session = NetworkMock()
#else
let session = WebFetchSession()
#endif
let app = GitHubExampleApp(networkSession: session)

let view = GitHubView(
    searchForm: document.getElementById("github-search-form"),
    repositoryList: document.getElementById("github-repository-list")
)

let viewController = GitHubViewController(view: view, app: app)
