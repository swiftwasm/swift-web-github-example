import GitHubExample

struct GitHubView {
    let searchForm: WebDocumentObject
    let repositoryList: WebDocumentObject

    func queryString() -> String {
        searchForm.query.object!.value.string!
    }

    func setRepositories(_ repos: [Repository]) {
        let innerHtml = repos.map {
            "<li>\($0.fullName)</li>"
        }.joined()

        view.repositoryList.innerHTML = innerHtml
    }
}
