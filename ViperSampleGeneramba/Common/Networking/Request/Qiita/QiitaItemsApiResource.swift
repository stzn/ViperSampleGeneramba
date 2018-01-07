import Foundation

final class QiitaItemsApiResource: ApiResource {
    
    typealias Model = [QiitaItem]
    
    var baseURL: String {
        return "https://qiita.com/api/v2"
    }
    
    var path: String {
        return "/items"
    }
    
    var method: HttpMethod {
        return .get
    }
    
    let parameter: ApiParameter
    init(query: String,
         page: Int,
         per_page: Int) {
        
        self.parameter = QiitaItemsParameter(
            query: query,
            page: page,
            per_page: per_page)
    }
}
