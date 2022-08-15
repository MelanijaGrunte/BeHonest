import Foundation
import Utility

public class Api {
    private let session = URLSession(
        configuration: .ephemeral,
        delegate: nil,
        delegateQueue: nil
    )
    private let apiKey = "94c2a5278c3f82241d33975b7d03238d"
    let domain = "https://ws.audioscrobbler.com"

    static public let shared = Api()

    public init() {}

    func requestWithMethod(
        _ httpMethod: HTTPMethod,
        endpoint: String,
        path: String,
        query: [String: Any]?,
        jsonBody: [String: Any]?
    ) -> URLRequest {
        var body: Data?
        if let jsonBody = jsonBody {
            do {
                body = try JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
        }
        var modifiedQuery = query
        modifiedQuery?["api_key"] = apiKey
        modifiedQuery?["format"] = "json"

        return requestWithMethod(httpMethod, endpoint: endpoint, path: path, query: modifiedQuery, body: body)
    }

    func requestWithMethod(
        _ httpMethod: HTTPMethod,
        endpoint: String,
        path: String,
        query: [String: Any]?,
        body: Data?
    ) -> URLRequest {
        var urlComponents = URLComponents(string: endpoint)
        if let query = query {
            let pairs = query.map { "\($0.key)=\(String(describing: $0.value))" }
            urlComponents?.query = pairs.joined(separator: "&")
        }
        if !path.hasPrefix("/") {
            urlComponents?.path = "/"
        }
        urlComponents?.path += path

        let url = urlComponents?.url
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.timeoutInterval = 30

        return request
    }

    func perform(
        request: URLRequest,
        completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    ) {
        session
            .dataTask(
                with: request,
                completionHandler: { data, response, error in
                    guard let data = data else {
                        print("No data found")
                        return completion(data, response, error)
                    }

                    completion(data, response, error)
                }
            )
            .resume()
    }
}

enum HTTPMethod: String {
    case POST, GET, PUT, DELETE, PATCH
}
