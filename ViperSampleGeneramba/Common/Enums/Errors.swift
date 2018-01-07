import Foundation

enum NetworkError: Error {
    case general(Error)
    case request(String)
    case parse(Error)
    case response(String)
    case invalidStatusCode(Int)
    
    var message: String {
        switch self {
        case .general(let error):
            return "General Error \(error.localizedDescription)"
        case .request(let message):
            return "Request Error \(message)"
        case .parse:
            return "Parse Error"
        case .response(let message):
            return "Response Error \(message)"
        case .invalidStatusCode(let code):
            return "Invalid Code \(code)"
        }
    }
}
