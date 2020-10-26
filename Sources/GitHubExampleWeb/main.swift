import GitHubExample
import JavaScriptKit

let window = WebDocumentObject(JSObject.global)
let document = WebDocument(JSObject.global.document.object!)
#if DEBUG
let session = NetworkMock()
#else
let session = WebFetchSession()
#endif
let app = GitHubExampleApp(networkSession: session)

let view = GitHubView(
    body: document.body,
    searchForm: document.getElementById("github-search-form"),
    repositoryList: document.getElementById("github-repository-list"),
    loadMoreTag: document.getElementById("github-load-more")
)

let viewController = GitHubViewController(view: view, app: app)
