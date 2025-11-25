import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

protocol FormURLEncodedRequest: NetworkRequest {
    /// Параметры для application/x-www-form-urlencoded
    var formParameters: [String: String] { get }
}

protocol EmptyBodyRequest: NetworkRequest {}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}
