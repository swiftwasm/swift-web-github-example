import GitHubExample
import Foundation

class NativeNetworkSession: NetworkSession {
    func get<R>(_ request: R, _ callback: @escaping (Result<R.Response, Error>) -> Void) where R: GitHubAPIRequest {
        let url = URL(string: request.baseURL + request.path + request.queryParameters.reduce("?") {
            $0 + ($0 == "?" ? "" : "&") + "\($1.key)=\($1.value)"
        })!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            do {
                let response = try JSONDecoder().decode(R.Response.self, from: data!)
                callback(.success(response))
            } catch {
                callback(.failure(error))
            }
        }
        task.resume()
    }
}
