import Foundation


struct API {}

extension API {
    
    static func handleResponse<T:Decodable>(data: Data?, response: URLResponse?, error: Error?) -> APIResult<T> {
        if let error = error {
            return APIResult.error(NetworkError.response(error.localizedDescription))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return APIResult.error(NetworkError.response("Can not Convert Response To HTTPURLResponse"))
        }
        
        guard (200 ..< 300) ~= httpResponse.statusCode else {
            return APIResult.error(NetworkError.invalidStatusCode(httpResponse.statusCode))
        }
        
        guard let data = data else {
            return APIResult.error(NetworkError.response("No Data"))
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return APIResult.response(decoded as T)
        } catch let error {
            print(error)
            return APIResult.error(NetworkError.parse(error))
        }
        
    }
}


