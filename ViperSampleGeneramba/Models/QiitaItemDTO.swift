import Foundation

struct QiitaItem: Decodable {
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
    struct Tag: Decodable {
        let name: String
    }
    
    struct User: Decodable {
        let github_login_name: String?
        let profile_image_url: String?
    }
}


