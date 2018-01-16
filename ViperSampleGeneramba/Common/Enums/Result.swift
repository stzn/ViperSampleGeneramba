import Foundation

enum Result<A> {
    case success(A)
    case error(Error)
}

extension Result {
    init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    var value: A? {
        guard case let .success(v) = self else { return nil }
        return v
    }
}
