import JavaScriptKit

func alert(_ message: String) {
    _ = JSObjectRef.global.alert!(message)
}
