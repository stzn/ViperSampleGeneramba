import Foundation

enum Result<A, E> {
    case success(A)
    case error(E)
}

extension Result {
    init(_ value: A?, or error: E) {
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
