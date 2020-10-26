import GitHubExample
import JavaScriptKit

struct MessageError: Error {
    let message: String
}

class WebFetchSession: NetworkSession {
    func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) where R: GitHubAPIRequest {
        let url = request.baseURL + request.path + request.queryParameters.reduce("?") {
            $0 + ($0 == "?" ? "" : "&") + "\($1.key)=\($1.value)"
        }
        fetch(url)
            .then { response in
                response.object!.json!()
            }
            .then { json -> JSValue in
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
            .catch { error -> Void in
                callback(.failure(MessageError(message: error.message)))
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

class NetworkMock: NetworkSession {

    static func decode<T: Decodable>(json: String) -> T {
        let json = WebJSON.parse(json)
        return try! JSValueDecoder().decode(from: json)
    }

    let responseMaps: [ResponseMapBase] = [
        ResponseMap<GitHubSearchRepositoryRequest>(
            response: decode(json: githubRepositoriesMock)
        )
    ]

    private var timer: JSTimer?
    func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) where R: GitHubAPIRequest {
        let response = responseMaps.first(where: { $0.requestType == R.self })!._response as! R.Response
        timer = JSTimer(millisecondsDelay: 1000) {
            callback(.success(response))
        }
    }
}
#endif
