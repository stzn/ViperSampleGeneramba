import Foundation

extension API {
    
    final class QiitaItemsApi {
        
        let apiRequest: ApiRequest<QiitaItemsApiResource>
        
        init(query: String, page: Int) {
            
            let apiResource = QiitaItemsApiResource(
                query: query,
                page: page,
                per_page: MaxResultsPerPage.QiitaItems)
            
            self.apiRequest = ApiRequest(resource: apiResource)
        }
        
        func fetchQiitaItemsData() -> Task<[QiitaItem], Error> {
            
            let task = Task<[QiitaItem], Error> { [weak self] result in
                self?.apiRequest.load() { apiResult in
                    return result(apiResult)
                }
            }
            return task
        }
    }
}
