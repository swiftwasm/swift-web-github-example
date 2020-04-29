import GitHubExample
import JavaScriptKit

class GitHubAPIImpl: GitHubAPI {
    let jsFetch = JSObjectRef.global.fetch.function!
    func searchRepositories(_ query: String, _ callback: @escaping ([Repository]) -> Void) {
        let url = "https://api.github.com/search/repositories?q=\(query)"
        let promise = jsFetch(url).object!
        _ = promise
            .then!(JSValue.function { args in
                return args[0].object!.json!()
            })
            .object!
            .then!(JSValue.function { args in
                let json = args[0].object!
                let items = json.items.object!
                let length = items.length.number!
                let repos = (0..<length).map { index -> Repository in
                    let data = items[Int(index)].object!
                    return Repository(
                        id: Int(data.id.number!),
                        fullName: data.full_name.string!
                    )
                }
                callback(repos)
                return .undefined
            })
    }
}
