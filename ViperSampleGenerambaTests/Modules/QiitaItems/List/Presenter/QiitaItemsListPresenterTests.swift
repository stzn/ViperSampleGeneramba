import XCTest

@testable import ViperSampleGeneramba

class QiitaItemsListPresenterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testsIsScrollUp() {
        
        let expectation: XCTestExpectation? = self.expectation(description: "scroll up")
        
        let view = QiitaItemsListViewControllerSpy()
        view.asyncScrollTopExpectation = expectation
        
        let interactor = QiitaItemsListInteractor()

        let presenter = QiitaItemsListPresenter(wireframe: QiitaItemsListWireframe(), view: view, interactor: interactor)
        
        interactor.output = presenter
        
        presenter.searchBarTextDidChange(text: "1")
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("error \(error.localizedDescription)")
            }
            XCTAssertTrue(view.isScrollTop)
        }
    }

    func testsShowQiitaItemsList() {
        
        let expectation: XCTestExpectation? = self.expectation(description: "show qiita items list")
        
        let view = QiitaItemsListViewControllerSpy()
        view.asyncExpectation = expectation
        
        let presenter = QiitaItemsListPresenter(wireframe: QiitaItemsListWireframe(), view: view, interactor: QiitaItemsListInteractor())
        
        let item = TestHelper.makeDummyQiitaItem()
        
        presenter.fetchedList(items: [item])
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("error \(error.localizedDescription)")
            }
            XCTAssertTrue(view.isShowQiitaItemList)
        }
    }

    func testsShowNoContent() {
        
        let expectation: XCTestExpectation? = self.expectation(description: "show no content")
        
        let view = QiitaItemsListViewControllerSpy()
        view.asyncExpectation = expectation
        
        let presenter = QiitaItemsListPresenter(wireframe: QiitaItemsListWireframe(), view: view, interactor: QiitaItemsListInteractor())
        
        presenter.fetchedList(items: [])
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("error \(error.localizedDescription)")
            }
            XCTAssertTrue(view.isShowNoContent)
        }
    }
    
    // MARK: - Test doubles
    
    class QiitaItemsListViewControllerSpy: UIViewController, QiitaItemsListViewInterface {
        
        var asyncExpectation: XCTestExpectation? = nil
        var asyncScrollTopExpectation: XCTestExpectation? = nil
        
        var isScrollTopTesting: Bool = false
        
        var isShowNoContent: Bool = false
        var isShowQiitaItemList: Bool = false
        var isScrollTop: Bool = false
        
        func showNoContentScreen() {
            
            guard asyncScrollTopExpectation == nil else { return }
            
            guard let expectation = asyncExpectation else {
                XCTFail("no expecation")
                return
            }
            isShowNoContent = true
            expectation.fulfill()
        }
        
        func showQiitaItemsList() {
            
            guard asyncScrollTopExpectation == nil else { return }
            
            guard let expectation = asyncExpectation else {
                XCTFail("no expecation")
                return
            }
            isShowQiitaItemList = true
            expectation.fulfill()
        }
        
        func scrolltoTop() {
            
            guard let expectation = asyncScrollTopExpectation else {
                XCTFail("no expecation")
                return
            }
            isScrollTop = true
            expectation.fulfill()
        }
    }
}


