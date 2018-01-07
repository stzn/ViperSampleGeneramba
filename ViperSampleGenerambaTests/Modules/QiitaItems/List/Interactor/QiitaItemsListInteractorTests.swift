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
    
    func testIsFetchList() {
        
        let wireFrame = QiitaItemsListWireframe()
        let view = QiitaItemsListViewControllerSpy()
        let interactor = QiitaItemsListInteractorSpy()
        
        let presenter = QiitaItemsListPresenter(wireframe: wireFrame, view: view, interactor: interactor)
        interactor.output = presenter
        
        view.presenter = presenter
        
        presenter.searchBarTextDidChange(text: "")
        
        let count = presenter.numberOfRows()
        
        XCTAssertEqual(count, 1)
    }
    
    
    class QiitaItemsListInteractorSpy: QiitaItemsListInteractorInterface {
        weak var output: QiitaItemsListInteractorOutputInterface?
        
        var asyncExpectation: XCTestExpectation?
        
        var isListFetch: Bool = false
        func fetchList(query: String, page: Int) {
            isListFetch = true
            output?.fetchedList(items: [TestHelper.makeDummyQiitaItem()])
        }
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


