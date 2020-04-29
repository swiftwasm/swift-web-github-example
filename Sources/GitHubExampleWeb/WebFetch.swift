import GitHubExample
import JavaScriptKit

let _jsFetch = JSObjectRef.global.get("fetch").function!
public func fetch(_ url: String) -> Promise {
    Promise(_jsFetch(url))!
}
