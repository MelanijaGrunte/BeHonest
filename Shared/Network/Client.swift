import Combine
import Utility

extension Client {
    static let live = Client { request in
        let request = Api.shared
            .requestWithMethod(
                HTTPMethod(rawValue: request.method) ?? .GET,
                endpoint: Api.shared.domain,
                path: request.path,
                query: request.params,
                jsonBody: request.body
            )

        return Future { promise in
            Api.shared.perform(request: request) { data, response, error in
                promise(.success(ClientResponse(data: data, error: error, response: response)))
            }
        }
        .eraseToAnyPublisher()
    }
}
