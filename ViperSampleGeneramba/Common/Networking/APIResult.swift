import Foundation

public enum APIResult<T> {
    case response(T)
    case error(Error)
}

public typealias ResultCallback<T> = (APIResult<T>) -> Void
