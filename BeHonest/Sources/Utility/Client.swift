import Foundation
import Combine

public struct ClientRequest {
    public let method: String
    public let path: String
    public let params: [String: Any]?
    public let body: [String: Any]?

    public init(
        method: String,
        path: String,
        params: [String: Any]? = nil,
        body: [String: Any]? = nil
    ) {
        self.method = method
        self.path = path
        self.params = params
        self.body = body
    }
}

public struct ClientResponse {
    public let data: Data?
    public let error: Error?
    public let response: URLResponse?

    public init(
        data: Data? = nil,
        error: Error? = nil,
        response: URLResponse? = nil
    ) {
        self.data = data
        self.error = error
        self.response = response
    }
}

//public struct DecodableResponse<Response: Decodable>: Decodable {
//    public let result: Response
//    public let code: Int
//}

public struct Client {
    public let request: (_ request: ClientRequest) -> AnyPublisher<ClientResponse, Never>

    public init(
        request: @escaping (_ request: ClientRequest) -> AnyPublisher<ClientResponse, Never>
    ) {
        self.request = request
    }
}
