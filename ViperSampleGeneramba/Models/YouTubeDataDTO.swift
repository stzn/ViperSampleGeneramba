import Foundation

struct YouTubeData: Decodable {
    
    let prevPageToken: String?
    let nextPageToken: String?
    let items: [Content]
    
    struct Content: Decodable {
        let id: Id
        let etag: String
        let kind: String
        let snippet: Snippet
        let contentDetails: ContentDetails?
        let statistics: Statistics?
        let status: Status?
    }
    
    struct Id: Decodable {
        let kind: String?
        let videoId: String?
        let channelId: String?
        let playlistId: String?
    }
    
    struct Snippet: Decodable {
        let channelId: String
        let title: String
        let description: String
        let publishedAt: String
        let thumbnails: Thumbnail
        
        struct Thumbnail:Decodable {
            let `default`: Default
            let medium: Medium
            let high: High
            
            struct Default: Decodable {
                let url: String
            }
            struct Medium: Decodable {
                let url: String
            }
            struct High: Decodable {
                let url: String
            }
        }
    }
    
    struct ContentDetails: Decodable {
        let duration: String
        let aspectRatio: String
    }
    
    struct Statistics: Decodable {
        let viewCount: Int
        let likeCount: Int
        let dislikeCount: Int
        let favoriteCount: Int
        let commentCount: Int
    }
    
    struct Status: Decodable {
        let updaloadStatus: String
        let privacyStatus: String
    }
}

extension YouTubeData {
    init() {
        self.init(prevPageToken: "", nextPageToken: "", items: [])
    }
}



