import UIKit

protocol SampleImageSelectWireframeInterface: WireframeInterface {
    func goToNextStep(_ output: UIImage?)
    func back()
}

protocol SampleImageSelectViewInterface: ViewInterface {
}

protocol SampleImageSelectPresenterInterface: PresenterInterface {
    func numerOfItems() -> Int
    func item(at: Int) -> UIImage?
    func didSelectImage(image: UIImage)
    func backButtonTapped()
}

protocol SampleImageSelectInteractorInterface: InteractorInterface {
}

protocol SampleImageSelectInteractorOutputInterface: InteractorOutputInterface {
}

protocol SampleImageSelectAPIDataManagerInterface: DataManagerInterface {
}

protocol SampleImageSelectLocalDataManagerInterface: DataManagerInterface {
}
