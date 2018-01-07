import Foundation

final class YouTubeSearchParameter {
    
    let q: String
    let key: String
    let part: String
    let maxResults: Int
    let order: String
    let pageToken: String
    
    init(q: String, key: String, part: YouTubeSearchPartParameter, maxResults: Int, order: String, pageToken: String) {
        let partList = part.setPartParameter()
        self.q = q
        self.key = key
        self.part = partList
        self.maxResults = maxResults
        self.order = order
        self.pageToken = pageToken        
    }
}

extension YouTubeSearchParameter: GetApiParameter {
    
    
    enum Keys: String, ParamKey {
        case q
        case key
        case part
        case maxResults
        case order
        case pageToken
    }
    
    var properties: Array<ParamKey> {
        return [Keys.q, Keys.key, Keys.part, Keys.maxResults, Keys.order, Keys.pageToken]
    }
    
    func valueForKey(key: ParamKey) -> Any? {
        switch key {
        case Keys.q:
            return q
        case Keys.key:
            return self.key
        case Keys.part:
            return part
        case Keys.maxResults:
            return maxResults
        case Keys.order:
            return order
        case Keys.pageToken:
            return pageToken
        default:
            return nil
        }
    }
}

struct YouTubeSearchPartParameter {

    enum Keys: String, ParamKey {
        case id
        case snippet
        case contentDetails
        case fileDetail
        case liveStreamingDetails
        case player
        case processingDetails
        case recordingDetails
        case statistics
        case status
        case suggestions
        case topicDetails
    }
    
    let list: [Keys]
    init(list: [Keys]) {
        self.list = list
    }
    
    func setPartParameter() -> String {
        return list.map { $0.stringValue }.joined(separator: ",")
    }
}
