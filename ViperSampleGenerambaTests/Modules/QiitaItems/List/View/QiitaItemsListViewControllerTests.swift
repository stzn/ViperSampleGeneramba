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
    
    func testViewDidLoad() {
        
        let presenter = QiitaItemsListPresenterSpy()
        
        listView = QiitaItemsListViewController.fromStoryboard()
        listView.presenter = presenter

        loadView()

        listView.viewDidLoad()
        
        XCTAssertTrue(presenter.isViewDidload)
    }
    
    func testDidSelectRow() {
        
        let presenter = QiitaItemsListPresenterSpy()
        
        listView = QiitaItemsListViewController.fromStoryboard()
        listView.presenter = presenter
        
        loadView()
        
        listView.tableView(listView.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(presenter.isDidSelectRow)
    }

    
    func testReloadData(){

        listView = QiitaItemsListViewController.fromStoryboard()
        
        let presenter = QiitaItemsListPresenterSpy()
        listView.presenter = presenter
        
        loadView()
        
        let tableView = TableViewSpy()
        listView.tableView = tableView

        listView.showQiitaItemsList()
        
        XCTAssertTrue(tableView.reloadDataCalled)
    }
    
    func loadView()
    {
        window.addSubview(listView.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    class QiitaItemsListPresenterSpy: QiitaItemsListPresenterInterface, QiitaItemsListInteractorOutputInterface {
        
        
        var asyncExpectation: XCTestExpectation?
        
        private var items: [QiitaItem] = [TestHelper.makeDummyQiitaItem()]
        
        var isViewDidload: Bool = false
        func viewDidLoad() {
            isViewDidload = true
        }
        
        var isSearchBarTextDidChange: Bool = false
        func searchBarTextDidChange(text: String) {
            isSearchBarTextDidChange = true
        }
        
        var isLoadMore: Bool = false
        func loadMore(searchText: String) {
            isLoadMore = true
        }
        
        var isDidSelectRow: Bool = false
        func didSelectRowAt(_ indexPath: IndexPath) {
            isDidSelectRow = true
        }
        
        func numberOfRows() -> Int {
            return items.count
        }

        func itemAt(_ indexPath: IndexPath) -> QiitaItem? {
            return items[0]
        }
        
        var isListFetched: Bool = false
        var isFetchFailed: Bool = false
        
        func fetchedList(items: [QiitaItem]) {
            isListFetched = true
        }
        
        func fetchedListError(error: Error) {
            isFetchFailed = true
        }
    }
    
    class QiitaItemsListInteractorSpy: QiitaItemsListInteractorInterface {
        
        weak var output = QiitaItemsListPresenterSpy()
        var isListFetch: Bool = false
        
        func fetchList(query: String, page: Int) {
            isListFetch = true
            output?.fetchedList(items: [])
        }
    }

    class TableViewSpy: UITableView {
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
}


