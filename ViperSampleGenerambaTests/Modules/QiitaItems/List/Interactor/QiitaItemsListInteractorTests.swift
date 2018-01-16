import XCTest

@testable import ViperSampleGeneramba

class QiitaItemsListInteractorTests: XCTestCase {

    var isListFetchedExpectation: XCTestExpectation? = nil
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    class QiitaItemsListViewControllerSpy: UIViewController, QiitaItemsListViewInterface {
        
        var presenter: QiitaItemsListPresenterInterface?
        
        var isShowNoContent: Bool = false
        func showNoContentScreen() {
            isShowNoContent = true
        }
        
        var isShowQiitaItemsList: Bool = false
        func showQiitaItemsList() {
            isShowQiitaItemsList = true
        }
        
        var isScrollTop: Bool = false
        func scrolltoTop() {
            isScrollTop = true
        }
    }
}


