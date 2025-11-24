import Foundation

// MARK: - GET /api/v1/orders/1

struct OrderGetRequest: NetworkRequest {
    private let path = "/api/v1/orders/1"
    
    var httpMethod: HttpMethod { .get }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    var dto: Encodable? { nil }
}

// MARK: - PUT /api/v1/orders/1

struct OrderPutRequest: NetworkRequest {
    private let path = "/api/v1/orders/1"
    let dtoModel: UpdateOrderDTO
    
    var httpMethod: HttpMethod { .put }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    var dto: Encodable? { dtoModel }
}

// MARK: - POST /api/v1/orders/1

struct OrderPostRequest: NetworkRequest {
    private let path = "/api/v1/orders/1"
    let dtoModel: UpdateOrderDTO
    
    var httpMethod: HttpMethod { .post }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    var dto: Encodable? { dtoModel }
}
