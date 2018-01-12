import UIKit

/// ストーリーボード上のUIViewControllerインスタンス作成プロトコル
protocol StoryboardLoadable: class {
    
    static var storyboardName: String { get }
    static var storyboardID: String? { get }
    
    static func fromStoryboard(withStoryboardID storyboardID: String?) -> Self
    static func fromStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    
    static var storyboardName: String {
        return "Main"
    }
    
    static var storyboardID: String? {
        return "\(self)"
    }
    
    static func fromStoryboard() -> Self {
        return fromStoryboard(withStoryboardID: storyboardID)
    }
    
    static func fromStoryboard(withStoryboardID storyboardID: String?) -> Self {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let storyboardID = storyboardID {
            return sb.instantiateViewController(withIdentifier: storyboardID) as! Self
        } else {
            return sb.instantiateInitialViewController() as! Self
        }
    }
}

