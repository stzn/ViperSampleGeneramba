import UIKit

final class SampleImageSelectPresenter {

    // MARK: - Private properties -

    fileprivate weak var _view: SampleImageSelectViewInterface?
    fileprivate var _interactor: SampleImageSelectInteractorInterface
    fileprivate var _wireframe: SampleImageSelectWireframeInterface

    private var _samples: [UIImage] = []
    
    // MARK: - Lifecycle -

    init(wireframe: SampleImageSelectWireframeInterface, view: SampleImageSelectViewInterface, interactor: SampleImageSelectInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        
        setSamples()
    }
    
    private func setSamples() {
        var i = 0
        repeat {
            guard let image = UIImage(named: "s\(i)") else { break }
            i += 1
            _samples.append(image)
        } while(true)
    }
}

// MARK: - Extensions -

extension SampleImageSelectPresenter: SampleImageSelectPresenterInterface {

    func numerOfItems() -> Int {
        return _samples.count
    }
    
    func item(at: Int) -> UIImage? {
        guard _samples.count - 1 >= at else { return nil }
        return _samples[at]
    }
    
    func didSelectImage(image: UIImage) {
        _wireframe.goToNextStep(image)
    }
    
    func backButtonTapped() {
        _wireframe.back()
    }

}

extension SampleImageSelectPresenter: SampleImageSelectInteractorOutputInterface {
}

