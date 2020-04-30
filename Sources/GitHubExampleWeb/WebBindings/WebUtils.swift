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

enum WebDevTool {
    static func debugger() {
        _ = JSObjectRef.global._triggerDebugger!()
    }
}

struct WebTimeoutID: JSValueConvertible {
    let ref: JSValue
    fileprivate init(_ ref: JSValue) {
        self.ref = ref
    }
    func jsValue() -> JSValue { ref }
}

func setTimeout(_ function: @escaping () -> Void, delay: Double) -> WebTimeoutID {
    let ref = JSObjectRef.global.setTimeout!(JSValue.function { _ in
        function()
        return .undefined
    }, JSValue.number(delay))
    return WebTimeoutID(ref)
}
