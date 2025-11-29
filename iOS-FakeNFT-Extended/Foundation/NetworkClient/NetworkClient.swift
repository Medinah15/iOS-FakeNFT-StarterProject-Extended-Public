import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case incorrectRequest(String)
}

protocol NetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest) async throws -> T
}

actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func send(request: NetworkRequest) async throws -> Data {
        let urlRequest = try create(request: request)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkClientError.urlSessionError
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("❌ HTTP ошибка: \(httpResponse.statusCode) для \(urlRequest.url?.absoluteString ?? "unknown")")
                if let errorString = String(data: data, encoding: .utf8) {
                    print("   Response body: \(errorString)")
                }
                throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
            }
            
            return data
        } catch let urlError as URLError {
            print("❌ Сетевая ошибка: \(urlError.localizedDescription) (код: \(urlError.code.rawValue))")
            throw NetworkClientError.urlRequestError(urlError)
        } catch {
            print("❌ Ошибка запроса: \(error.localizedDescription)")
            throw NetworkClientError.urlRequestError(error)
        }
    }
    
    func send<T: Decodable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try parse(data: data)
    }
    
    // MARK: - Private
    
    private func create(request: NetworkRequest) throws -> URLRequest {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        // -------------------------------------------
        // 1) form-urlencoded (наш случай с orders)
        // -------------------------------------------
        if let formRequest = request as? FormURLEncodedRequest {
            let formParams = formRequest.formParameters
            
            // Если параметров нет, отправляем пустое тело
            guard !formParams.isEmpty else {
                urlRequest.httpBody = Data()
                urlRequest.setValue("application/x-www-form-urlencoded",
                                    forHTTPHeaderField: "Content-Type")
                return urlRequest
            }
            
            let bodyString = formParams
                .map { key, value in
                    let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                    let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
                    return "\(encodedKey)=\(encodedValue)"
                }
                .joined(separator: "&")
            
            guard let bodyData = bodyString.data(using: .utf8) else {
                throw NetworkClientError.incorrectRequest("Failed to encode form body")
            }
            
            urlRequest.httpBody = bodyData
            urlRequest.setValue("application/x-www-form-urlencoded",
                                forHTTPHeaderField: "Content-Type")
            
            // -------------------------------------------
            // 2) JSON (старый сценарий, если есть dto)
            // -------------------------------------------
        } else if let dto = request.dto {
            if let dtoEncoded = try? encoder.encode(dto) {
                urlRequest.httpBody = dtoEncoded
                urlRequest.setValue("application/json",
                                    forHTTPHeaderField: "Content-Type")
            }
        }
        
        // -------------------------------------------
        // Token — добавляется только для запросов к нашему API
        // -------------------------------------------
        if let endpointHost = endpoint.host,
           endpointHost.contains("apigw.yandexcloud.net") {
            urlRequest.addValue(RequestConstants.token,
                                forHTTPHeaderField: "X-Practicum-Mobile-Token")
        }
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("❌ Ошибка декодирования JSON:")
                print("   Ответ: \(jsonString.prefix(500))")
            }
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("   Тип не совпадает: \(type), путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .valueNotFound(let type, let context):
                print("   Значение не найдено: \(type), путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .keyNotFound(let key, let context):
                print("   Ключ не найден: \(key.stringValue), путь: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .dataCorrupted(let context):
                print("   Данные повреждены: \(context.debugDescription)")
            @unknown default:
                print("   Неизвестная ошибка декодирования")
            }
            throw NetworkClientError.parsingError
        } catch {
            print("❌ Ошибка парсинга: \(error.localizedDescription)")
            throw NetworkClientError.parsingError
        }
    }
}
