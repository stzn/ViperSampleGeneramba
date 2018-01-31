import UIKit

protocol ProfileImageSelectWireframeInterface: WireframeInterface {
    func goToNextStep(_ output: ProfileImageType?)
    func back()
}

protocol ProfileImageSelectViewInterface: ViewInterface {
}

protocol ProfileImageSelectPresenterInterface: PresenterInterface {
    func selectSampleButtonTapped()
    func confirmButtonTapped(image: UIImage)
    func backButtonTapped()
}

protocol ProfileImageSelectInteractorInterface: InteractorInterface {
}

protocol ProfileImageSelectInteractorOutputInterface: InteractorOutputInterface {
}

protocol ProfileImageSelectAPIDataManagerInterface: DataManagerInterface {
}

protocol ProfileImageSelectLocalDataManagerInterface: DataManagerInterface {
}
