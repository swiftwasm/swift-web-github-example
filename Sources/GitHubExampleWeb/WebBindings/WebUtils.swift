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

struct WebTimeoutID: ConvertibleToJSValue {
    let ref: JSValue
    fileprivate init(_ ref: JSValue) {
        self.ref = ref
    }
    func jsValue() -> JSValue { ref }
}

func setTimeout(_ function: @escaping () -> Void, delay: Double) -> WebTimeoutID {
    let ref = JSObject.global.setTimeout!(JSValue.function { _ in
        function()
        return .undefined
    }, JSValue.number(delay))
    return WebTimeoutID(ref)
}
