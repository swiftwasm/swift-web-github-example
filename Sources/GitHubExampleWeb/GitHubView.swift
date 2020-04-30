import GitHubExample

struct GitHubView {
    let body: WebDocumentObject
    let searchForm: WebDocumentObject
    let repositoryList: WebDocumentObject
    let loadMoreTag: WebDocumentObject

    func queryString() -> String {
        searchForm.query.object!.value.string!
    }

    func setRepositories(_ repos: [Repository]) {

        loadMoreTag.innerHTML = repos.isEmpty ? "" : loadMoreView()

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
                <p>\(repo.description ?? "")</p>
            </div>
        </article>
        """
    }

    func loadMoreView() -> String {
        return """
            <div class="loading-icon">
                <svg viewBox="0 0 32 32">
                    <circle cx="16" cy="16" fill="none" r="14" stroke-width="4" style="stroke: rgb(204, 204, 204); opacity: 0.2;"></circle>
                    <circle cx="16" cy="16" fill="none" r="14" stroke-width="4" style="stroke: rgb(180, 180, 180); stroke-dasharray: 80; stroke-dashoffset: 60;"></circle>
                </svg>
            </div>
        """
    }
}
