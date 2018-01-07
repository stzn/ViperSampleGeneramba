import Foundation

protocol ApiResource {
    associatedtype Model: Decodable
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var parameter: ApiParameter { get }
    func makeModel(data: Data) throws -> Model
}

extension ApiResource {
    
    var request: URLRequest? {
        let urlString = baseURL + path
        switch method {
        case .get:
            guard var components = URLComponents(string: urlString) else {
                return nil
            }
            guard let parameter = parameter as? GetApiParameter else {
                return nil
            }

            components.queryItems = parameter.makeQueryItem()
            var urlRequest = URLRequest(url: components.url!)
            urlRequest.httpMethod = method.string
            return urlRequest
            
        case .post:
            guard let url = URL(string: urlString) else {
                return nil
            }

            guard let parameter = parameter as? PostApiParameter else {
                return nil
            }
            
            var urlRequest = URLRequest(url: url)
            
            let parameterString = parameter.makeParameterString()
            if !parameterString.isEmpty {
                urlRequest.httpBody = parameterString.data(using: .utf8)
            }
            urlRequest.httpMethod = method.string
            return urlRequest
        }
    }
    
    func makeModel(data: Data) throws -> Model {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: data)
    }
}
