import JavaScriptKit

@dynamicMemberLookup
class JSObjectProxyBase: JSValueConvertible {
    var ref: JSObjectRef
    init(_ ref: JSObjectRef) {
        self.ref = ref
    }
    func jsValue() -> JSValue {
        return .object(ref)
    }
}

extension JSObjectProxyBase {
    subscript(dynamicMember name: String) -> ((JSValueConvertible...) -> JSValue)? {
        return ref[dynamicMember: name]
    }
    subscript(dynamicMember name: String) -> JSValue {
        get { ref[dynamicMember: name] }
        set { ref[dynamicMember: name] = newValue }
    }
    subscript(_ index: Int) -> JSValue {
        get { ref[index] }
        set { ref[index] = newValue }
    }

    func get(_ name: String) -> JSValue { ref.get(name) }
    func set(_ name: String, _ value: JSValue) { ref.set(name, value)}
    func get(_ index: Int) -> JSValue { ref.get(index) }
    func set(_ index: Int, _ value: JSValue) { ref.set(index, value) }
}

class WebDocumentEvent {
    private let ref: JSObjectRef

    init(_ ref: JSObjectRef) {
        self.ref = ref
    }

    func preventDefault() {
        _ = ref.preventDefault!()
    }
}

class WebDocument: JSObjectProxyBase {
    var body: WebDocumentObject { WebDocumentObject(ref.body.object!) }
    func getElementById(_ id: String) -> WebDocumentObject {
        WebDocumentObject(ref.getElementById!(id).object!)
    }

    func createElement(_ tag: String) -> WebDocumentObject {
        WebDocumentObject(ref.createElement!(tag).object!)
    }
}

class WebDocumentObject: JSObjectProxyBase {

    var innerHTML: String {
        get { ref.get(#function).string! }
        set { ref.set(#function, .string(newValue)) }
    }

    var innerText: String {
        get { ref.get(#function).string! }
        set { ref.set(#function, .string(newValue)) }
    }

    @discardableResult
    func appendChild(_ child: WebDocumentObject) -> WebDocumentObject {
        WebDocumentObject(ref.appendChild!(child).object!)
    }

    func addEventListener(_ eventType: String, listener: @escaping (WebDocumentEvent) -> Void) {
        _ = ref.addEventListener!(eventType, JSValue.function { args in
            let event = WebDocumentEvent(args[0].object!)
            listener(event)
            return .undefined
        })
    }
}

class WebIntersectionObserver: JSObjectProxyBase {
    static let ref = JSObjectRef.global.IntersectionObserver.function!

    struct Entry: Codable {
        let isIntersecting: Bool
    }

    init(_ callback: @escaping ([Entry]) -> Void) {
        super.init(Self.ref.new(JSValue.function { args in
            let entries: [Entry] = try! JSValueDecoder().decode(from: args[0])
            callback(entries)
            return .undefined
        }))
    }

    func observe(_ target: WebDocumentObject) {
        _ = ref.observe!(target)
    }
}
