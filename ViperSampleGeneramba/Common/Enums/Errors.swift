import Foundation

enum NetworkError: Error {
    case general(Error)
    case request(String)
    case parse(Error)
    case response(String)
    case invalidStatusCode(Int)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
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

enum ValidationError: String, Error {
    case loginRequired = "ログインIDとパスワードは必ず入力してください"
    case loginFailed = "ログインIDまたはパスワードが間違っています。"
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        return self.rawValue
    }
}

enum OtherError: Error {
    case unexpected(Error)
    case unknownError
}

extension OtherError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .unexpected(error):
            return "エラー: \(error.localizedDescription)"
        case .unknownError:
            return "Unknownエラー"
        }
    }
}
