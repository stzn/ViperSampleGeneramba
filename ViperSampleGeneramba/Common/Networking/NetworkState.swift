import Foundation

enum TriggerType {
    case refresh
    case loadMore
    case searchTextChange
}

enum NetworkState: Equatable {
    
    case nothing
    case requesting
    case error(Error)
    case reachedBottom
    
    static func ==(lhs: NetworkState, rhs: NetworkState) -> Bool {
        switch (lhs, rhs) {
        case (.error, .error):
            return true
        case (.nothing, .nothing):
            return true
        case (.requesting, .requesting):
            return true
        case (.reachedBottom, .reachedBottom):
            return true
        default:
            return false
        }
    }
}
