import GitHubExample
import JavaScriptKit

let _jsFetch = JSObject.global.fetch.function!
public func fetch(_ url: String) -> JSPromise<JSValue, JSError> {
    JSPromise(_jsFetch(url).object!)!
}
