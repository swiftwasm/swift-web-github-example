import GitHubExample
import JavaScriptKit

struct MessageError: Error {
    let message: String
}

class WebFetchSession: SessionType {
    func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) where R: GitHubAPIRequest {
        let url = request.baseURL + request.path + request.queryParameters.reduce("?") {
            $0 + "\($1.key)=\($1.value)"
        }
        _ = fetch(url)
            .then { response in
                response.object!.json!()
            }
            .then { json in
                do {
                    let response = try JSValueDecoder().decode(
                        R.Response.self, from: json
                    )
                    callback(.success(response))
                } catch {
                    callback(.failure(error))
                }
                return .undefined
            }
            .catch { error in
                callback(.failure(MessageError(message: error.object!.message.string!)))
            }
    }
}

#if DEBUG

protocol ResponseMapBase {
    var requestType: Any.Type { get }
    var _response: Any { get }
}

struct ResponseMap<T: GitHubAPIRequest>: ResponseMapBase {
    var requestType: Any.Type { T.self }
    let response: T.Response
    var _response: Any { return response }
}

class SessionMock: SessionType {

    let responseMaps: [ResponseMapBase] = [
        ResponseMap<GitHubSearchRepositoryRequest>(response: .init(items: [
            Repository(id: 44838949,  fullName: "apple/swift"),
            Repository(id: 790019,    fullName: "openstack/swift"),
            Repository(id: 130902948, fullName: "tensorflow/swift"),
            Repository(id: 20822291,  fullName: "ipader/SwiftGuide"),
            Repository(id: 20965586,  fullName: "SwiftyJSON/SwiftyJSON"),
            Repository(id: 64705781,  fullName: "SwifterSwift/SwifterSwift"),
            Repository(id: 35732214,  fullName: "realm/SwiftLint"),
            Repository(id: 94066125,  fullName: "iOS-Swift-Developers/Swift"),
            Repository(id: 4276357,   fullName: "facebookarchive/swift"),
            Repository(id: 27896005,  fullName: "jaguar07/Swift"),
            Repository(id: 20682114,  fullName: "JakeLin/SwiftLanguageWeather"),
            Repository(id: 33569135,  fullName: "ReactiveX/RxSwift"),
            Repository(id: 21696302,  fullName: "matteocrippa/awesome-swift"),
            Repository(id: 35143711,  fullName: "malcommac/SwiftDate"),
            Repository(id: 22458259,  fullName: "Alamofire/Alamofire"),
            Repository(id: 65219683,  fullName: "SwiftKickMobile/SwiftMessages"),
            Repository(id: 39166950,  fullName: "SwiftGen/SwiftGen"),
            Repository(id: 50447720,  fullName: "raywenderlich/swift-algorithm-club"),
            Repository(id: 20430314,  fullName: "fullstackio/FlappySwift"),
            Repository(id: 56840338,  fullName: "garnele007/SwiftOCR"),
            Repository(id: 63729462,  fullName: "airbnb/swift"),
            Repository(id: 45497910,  fullName: "apple/swift-evolution"),
            Repository(id: 41854508,  fullName: "bizz84/SwiftyStoreKit"),
            Repository(id: 47025785,  fullName: "SwiftyBeaver/SwiftyBeaver"),
            Repository(id: 93580,     fullName: "swiftmailer/swiftmailer"),
            Repository(id: 20489806,  fullName: "HunkSmile/Swift"),
            Repository(id: 46155445,  fullName: "937447974/Swift"),
            Repository(id: 39890718,  fullName: "malcommac/SwiftLocation"),
            Repository(id: 190707613, fullName: "Juanpe/About-SwiftUI"),
            Repository(id: 20429943,  fullName: "SwiftGGTeam/the-swift-programming-language-in-chinese")
        ]))
    ]

    func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) where R : GitHubAPIRequest {
        let response = responseMaps.first(where: { $0.requestType == R.self })!._response as! R.Response
        callback(.success(response))
    }
}
#endif
