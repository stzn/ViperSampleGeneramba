import Foundation
import RxSwift

final class QiitaItemsListInteractor {
    
    weak var output: QiitaItemsListInteractorOutputInterface?
    
    // 参照を保持しておく必要がある
    private var api: API.QiitaItemsApi!
}

// MARK: - Extensions -

extension QiitaItemsListInteractor: QiitaItemsListInteractorInterface {
    func fetchList(query: String, page: Int) -> Single<Result<[QiitaItem]>> {
    
        api = API.QiitaItemsApi.init(query: query, page: page)
    
        return Single.create(subscribe: { [weak self] observer in

            guard let `self` = self else {
                observer(.error(OtherError.unknownError))
                return Disposables.create()
            }
            
            self.api.fetchQiitaItemsData().response { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .response(let data):
                        observer(.success(Result.success(data)))
                    case .error(let error):
                        observer(.error(error))
                    }
                }
            }
            return Disposables.create()
        })

    }
    
}

