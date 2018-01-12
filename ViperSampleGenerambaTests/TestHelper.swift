import Foundation

@testable import ViperSampleGeneramba

struct TestHelper {
    static func makeDummyQiitaItem() -> QiitaItem {
        return QiitaItem(id: "id", likes_count: 1, reactions_count: 1, comments_count: 1, title: "title", created_at: "2000-01-01T00:00:00+09:00", updated_at: "2000-01-01T00:00:00+09:00", url: URL(string: "https://www.apple.com")!, tags: [], user: nil)
    }
}
