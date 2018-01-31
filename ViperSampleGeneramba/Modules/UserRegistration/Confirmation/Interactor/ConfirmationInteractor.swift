import Foundation

final class ConfirmationInteractor {
    
    weak var output: ConfirmationInteractorOutputInterface?
    var APIDataManager: ConfirmationAPIDataManagerInterface?
    var localDataManager: ConfirmationLocalDataManagerInterface?
}

// MARK: - Extensions -

extension ConfirmationInteractor: ConfirmationInteractorInterface {
}

