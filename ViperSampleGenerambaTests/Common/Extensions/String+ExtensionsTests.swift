import XCTest

@testable import ViperSampleGeneramba

class String_ExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConvertDateString() {
        
        let dateString = "2000-01-01T00:00:00+09:00"
        let formatted = dateString.convertDateFormat(from: DateFormat.ISO8601Format, to: DateFormat.japaneseFormat)        
        XCTAssertEqual(formatted, "2000年01月01日00時00分")
    }
}
