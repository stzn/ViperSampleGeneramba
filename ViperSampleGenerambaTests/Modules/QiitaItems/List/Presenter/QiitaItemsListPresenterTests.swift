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
        
        var isScrollTop: Bool = false

        
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


