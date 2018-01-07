import Foundation

final class QiitaItemsParameter {
    
    let query: String
    let page: Int
    let per_page: Int
    
    init(query: String, page: Int, per_page: Int) {
        self.query = query
        self.page = page
        self.per_page = per_page
    }
}

extension QiitaItemsParameter: GetApiParameter {
    
    
    enum Keys: String, ParamKey {
        case query
        case page
        case per_page
    }
    
    var properties: Array<ParamKey> {
        return [Keys.query, Keys.page, Keys.per_page]
    }
    
    func valueForKey(key: ParamKey) -> Any? {
        switch key {
        case Keys.query:
            return query
        case Keys.page:
            return page
        case Keys.per_page:
            return per_page
        default:
            return nil
        }
    }
}
