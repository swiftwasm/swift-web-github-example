import JavaScriptKit

func alert(_ message: String) {
    _ = JSObject.global.alert!(message)
}

class WebConsole: JSObjectProxyBase {
    func log(_ text: String...) {
        _ = ref.log!(text.joined(separator: " "))
    }

    func log(_ value: JSValue) {
        _ = ref.log!(value)
    }
}

let console = WebConsole(JSObject.global.console.object!)

enum WebDevTool {
    static func debugger() {
        _ = JSObject.global._triggerDebugger!()
    }
}

