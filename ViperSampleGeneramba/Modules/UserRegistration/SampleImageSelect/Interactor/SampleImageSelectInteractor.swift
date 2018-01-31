import Foundation

final class SampleImageSelectInteractor {
    
    weak var output: SampleImageSelectInteractorOutputInterface?
    var APIDataManager: SampleImageSelectAPIDataManagerInterface?
    var localDataManager: SampleImageSelectLocalDataManagerInterface?
}

// MARK: - Extensions -

extension SampleImageSelectInteractor: SampleImageSelectInteractorInterface {
}

