import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    
    var string: String {
        return rawValue
    }
}
