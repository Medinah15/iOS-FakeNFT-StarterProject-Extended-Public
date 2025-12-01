import Foundation

// MARK: - GET /api/v1/orders/1

struct OrderGetRequest: NetworkRequest {
    private let path = "/api/v1/orders/1"

    var httpMethod: HttpMethod { .get }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }
    var dto: Encodable? { nil }
}

// MARK: - PUT /api/v1/orders/1

struct OrderPutRequest: NetworkRequest, FormURLEncodedRequest {
    private let path = "/api/v1/orders/1"
    let nftIds: [String]

    var httpMethod: HttpMethod { .put }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }

    var dto: Encodable? { nil }

    /// PUT обновляет корзину, но не умеет очищать.
    var formParameters: [String : String] {
        if nftIds.isEmpty {
            // PUT с пустым body вызывает ошибку -> {"error":"entity by id is missing"}
            // Поэтому НЕ шлём пустой PUT, а пусть вызывающий код сам решает, что делать.
            return [:]
        } else {
            return ["nfts": nftIds.joined(separator: ",")]
        }
    }
}

// MARK: - POST /api/v1/orders/1

struct OrderPostRequest: NetworkRequest, FormURLEncodedRequest {
    private let path = "/api/v1/orders/1"
    let nftIds: [String]

    var httpMethod: HttpMethod { .post }
    var endpoint: URL? { URL(string: RequestConstants.baseURL + path) }

    var dto: Encodable? { nil }

    /// POST по спецификации выполняет заказ и очищает корзину
    /// Но сервер НЕ принимает nfts вообще —  шлём пустое тело..
    var formParameters: [String: String] {
        return [:]
    }
}

// MARK: - GET /orders/1/payment/{currency_id}

struct PayOrderRequest: NetworkRequest {
    let orderId: String
    let currencyId: String

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/orders/\(orderId)/payment/\(currencyId)")
    }

    var dto: Encodable? { nil }
}
