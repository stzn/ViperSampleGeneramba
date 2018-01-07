import Foundation

final class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension ApiRequest: NetworkRequest {
    
    typealias Model = Resource.Model
    
    func load(withCompletion completion: @escaping (APIResult<Model>) -> Void) {
        guard let request = resource.request else {
            return
        }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        print(request)
        
        let task = session.dataTask(with: request) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let strongSelf = self else {
                completion(APIResult.error(NetworkError.response("no self")))
                return
            }
            completion(strongSelf.handleResponse(data: data, response: response, error: error))
        }
        task.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> APIResult<Model> {
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
            let decoded = try self.decode(data)
            return APIResult.response(decoded as Model)
        } catch let error {
            return APIResult.error(NetworkError.parse(error))
        }
    }

    func decode(_ data: Data) throws -> Model {
        return try resource.makeModel(data: data)
    }
}
