import GitHubExample

struct GitHubView {
    let searchForm: WebDocumentObject
    let repositoryList: WebDocumentObject

    func queryString() -> String {
        searchForm.query.object!.value.string!
    }

    func setRepositories(_ repos: [Repository]) {
        let innerHtml = repos.map {
            repositoryView(repo: $0)
        }.joined()

        view.repositoryList.innerHTML = innerHtml
    }

    func repositoryView(repo: Repository) -> String {
        """
        <article class="github-repository">
            <img class="github-thumb" src="\(repo.owner.avatarURL)" />
            <div class="github-repository-content">
                <h3 class="github-repository-name">
                    <a href="\(repo.htmlURL)">\(repo.fullName)</a>
                </h3>
                <p>\(repo.description)</p>
            </div>
        </article>
        """
    }
}
