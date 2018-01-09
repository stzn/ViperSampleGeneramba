import Foundation

final class QiitaItemsListInteractor {
    
    weak var output: QiitaItemsListInteractorOutputInterface?
    
    // 参照を保持しておく必要がある
    private var api: API.QiitaItemsApi!
}

// MARK: - Extensions -

extension QiitaItemsListInteractor: QiitaItemsListInteractorInterface {
    
    func fetchList(query: String, page: Int) {
        
        api = API.QiitaItemsApi.init(query: query, page: page)
        
        let _ = api.fetchQiitaItemsData().response { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .response(let data):
                    self?.output?.fetchedList(items: data)
                case .error(let error):
                    self?.output?.fetchedListError(error: error)
                }
            }
        }

    }
    
}

