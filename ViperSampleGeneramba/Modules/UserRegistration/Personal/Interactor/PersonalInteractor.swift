import Foundation

final class PersonalInteractor {
    
    weak var output: PersonalInteractorOutputInterface?
    var APIDataManager: PersonalAPIDataManagerInterface?
    var localDataManager: PersonalLocalDataManagerInterface?
}

// MARK: - Extensions -

extension PersonalInteractor: PersonalInteractorInterface {
}

