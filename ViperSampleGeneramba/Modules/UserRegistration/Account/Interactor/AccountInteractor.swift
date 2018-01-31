import Foundation

final class AccountInteractor {
    
    weak var output: AccountInteractorOutputInterface?
    var APIDataManager: AccountAPIDataManagerInterface?
    var localDataManager: AccountLocalDataManagerInterface?
}

// MARK: - Extensions -

extension AccountInteractor: AccountInteractorInterface {
}

