import JavaScriptKit

@dynamicMemberLookup
class JSObjectProxyBase: ConvertibleToJSValue {
    var ref: JSObject!
    init(_ ref: JSObject) {
        self.ref = ref
    }
    func jsValue() -> JSValue {
        return .object(ref)
    }
}

extension JSObjectProxyBase {
    subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)? {
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

    func get(_ name: String) -> JSValue { ref[name] }
    func set(_ name: String, _ value: JSValue) { ref[name] = value }
    func get(_ index: Int) -> JSValue { ref[index] }
    func set(_ index: Int, _ value: JSValue) { ref[index] = value }
}

class WebDocumentEvent {
    private let ref: JSObject

    init(_ ref: JSObject) {
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
        get { ref[#function].string! }
        set { ref[#function] = .string(newValue) }
    }

    var innerText: String {
        get { ref[#function].string! }
        set { ref[#function] = .string(newValue) }
    }

    @discardableResult
    func appendChild(_ child: WebDocumentObject) -> WebDocumentObject {
        WebDocumentObject(ref.appendChild!(child).object!)
    }

    private var subscriptions: [(event: String, listener: JSClosure)] = []
    func addEventListener(_ eventType: String, listener: @escaping (WebDocumentEvent) -> Void) {
        let listener = JSClosure { args -> JSValue in
            let event = WebDocumentEvent(args[0].object!)
            listener(event)
            return .undefined
        }
        subscriptions.append((event: eventType, listener: listener))
        _ = ref.addEventListener!(eventType, listener)
    }

    deinit {
        for (event, listener) in subscriptions {
            _ = ref.removeEventListener!(event, listener)
        }
    }
}

class WebIntersectionObserver: JSObjectProxyBase {
    static let ref = JSObject.global.IntersectionObserver.function!

    struct Entry: Codable {
        let isIntersecting: Bool
    }

    let jsClosure: JSClosure
    init(_ callback: @escaping ([Entry]) -> Void) {
        jsClosure = JSClosure { args -> JSValue in
            let entries: [Entry] = try! JSValueDecoder().decode(from: args[0])
            callback(entries)
            return .undefined
        }
        super.init(Self.ref.new(jsClosure))
    }

    func observe(_ target: WebDocumentObject) {
        _ = ref.observe!(target)
    }

    deinit {
        // Release JSClosure **after** releasing IntersectionObserver
        // to avoid use-after-free
        ref = nil
        jsClosure.release()
    }
}
