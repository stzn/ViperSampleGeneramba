import UIKit
import WebKit

final class QiitaItemDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Public properties -

    var presenter: QiitaItemDetailPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }	
}

// MARK: - Extensions -

extension QiitaItemDetailViewController: QiitaItemDetailViewInterface {
    func showWebView(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
}

extension QiitaItemDetailViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.QiitaItemDetailViewController.name
    }
}

