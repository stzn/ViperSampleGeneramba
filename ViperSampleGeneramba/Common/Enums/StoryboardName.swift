import Foundation

enum StoryboardName: String  {
    
    // Root
    case SplashViewController = "SplashViewController"

    // Login
    case LoginViewController = "LoginViewController"
    
    // Youtube
    case QiitaItemsListViewController = "QiitaItemsListViewController"
    case QiitaItemDetailViewController = "QiitaItemDetailViewController"

    var name: String {
        return self.rawValue
    }
}
