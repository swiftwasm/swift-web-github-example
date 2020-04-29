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
