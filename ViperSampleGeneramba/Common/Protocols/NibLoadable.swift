import UIKit

protocol NibLoadable: class {
    static var NibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var NibName: String {
        return String(describing: self)
    }
}
