import Foundation

struct QiitaItem: Decodable, Equatable {
    static func ==(lhs: QiitaItem, rhs: QiitaItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.likes_count == rhs.likes_count
            && lhs.reactions_count == rhs.reactions_count
            && lhs.comments_count == rhs.comments_count
            && lhs.title == rhs.title
            && lhs.created_at == rhs.created_at
            && lhs.updated_at == rhs.updated_at
            && lhs.url == rhs.url
            && lhs.tags == rhs.tags
            && lhs.user == rhs.user
    }
    
    let id: String
    let likes_count: Int
    let reactions_count: Int
    let comments_count: Int
    let title: String
    let created_at: String
    let updated_at: String
    let url: URL
    let tags: [Tag]
    let user: User?
    
    struct Tag: Decodable, Equatable {
        static func ==(lhs: QiitaItem.Tag, rhs: QiitaItem.Tag) -> Bool {
            return lhs.name == rhs.name
        }
        let name: String
    }
    
    struct User: Decodable, Equatable {
        static func ==(lhs: QiitaItem.User, rhs: QiitaItem.User) -> Bool {
            return lhs.github_login_name == rhs.github_login_name
            && lhs.profile_image_url == rhs.profile_image_url
        }
        
        let github_login_name: String?
        let profile_image_url: String?
    }
}


