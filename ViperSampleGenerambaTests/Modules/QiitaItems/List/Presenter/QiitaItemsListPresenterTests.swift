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


