import JavaScriptKit

func alert(_ message: String) {
    _ = JSObjectRef.global.alert!(message)
}

class WebConsole: JSObjectProxyBase {
    func log(_ text: String...) {
        _ = ref.log!(text.joined(separator: " "))
    }

    func log(_ value: JSValue) {
        _ = ref.log!(value)
    }
}

let console = WebConsole(JSObjectRef.global.get("console").object!)
