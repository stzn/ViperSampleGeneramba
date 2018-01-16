import UIKit

final class SplashViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: SplashPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }	
}

// MARK: - Extensions -

extension SplashViewController: SplashViewInterface {
}

extension SplashViewController: StoryboardLoadable {
    static var storyboardName: String {
        return StoryboardName.SplashViewController.name
    }
}

