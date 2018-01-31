import Foundation

final class ProfileImageSelectInteractor {
    
    weak var output: ProfileImageSelectInteractorOutputInterface?
    var APIDataManager: ProfileImageSelectAPIDataManagerInterface?
    var localDataManager: ProfileImageSelectLocalDataManagerInterface?
}

// MARK: - Extensions -

extension ProfileImageSelectInteractor: ProfileImageSelectInteractorInterface {
}

