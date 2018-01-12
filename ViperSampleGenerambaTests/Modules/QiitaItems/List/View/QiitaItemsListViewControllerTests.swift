import XCTest

@testable import ViperSampleGeneramba

class QiitaItemsListViewTests: XCTestCase {

    var window: UIWindow!
    var listView: QiitaItemsListViewController!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func loadView()
    {
        window.addSubview(listView.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
}


