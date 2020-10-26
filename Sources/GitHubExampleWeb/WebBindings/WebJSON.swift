import JavaScriptKit

class WebJSON {
    static let ref = JSObject.global.JSON.object!
    static func stringify(_ object: JSValue) -> String {
        ref.stringify!(object).string!
    }

    static func parse(_ string: String) -> JSValue {
        ref.parse!(string)
    }
}
