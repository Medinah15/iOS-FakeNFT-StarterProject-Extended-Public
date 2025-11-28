import Foundation

struct UsersRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var endpoint: URL? { 
        URL(string: RequestConstants.baseURL + "/api/v1/users") 
    }
    var dto: Encodable? { nil }
}

struct UserDetailsRequest: NetworkRequest {
    let id: String
    var httpMethod: HttpMethod { .get }
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/users/\(id)")
    }
    var dto: Encodable? { nil }
}
