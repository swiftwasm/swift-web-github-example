import GitHubExample
import JavaScriptKit

let _jsFetch = JSObject.global.fetch.function!
public func fetch(_ url: String) -> Promise {
    Promise(_jsFetch(url))!
}
