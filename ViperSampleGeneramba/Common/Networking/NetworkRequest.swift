import Foundation

protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (APIResult<Model>) -> Void)
    func decode(_ data: Data) throws -> Model
}

extension NetworkRequest {
    
}
