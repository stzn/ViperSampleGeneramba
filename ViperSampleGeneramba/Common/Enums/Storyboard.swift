import Foundation

enum Storyboard: String  {
    
    // Root
    case SplashViewController = "SplashViewController"

    // Login
    case LoginViewController = "LoginViewController"
    
    // Qiita
    case QiitaItemsListViewController = "QiitaItemsListViewController"
    case QiitaItemDetailViewController = "QiitaItemDetailViewController"

    // UserRegistration
    case PersonalViewController = "PersonalViewController"
    case AccountViewController = "AccountViewController"
    case ConfirmationViewController = "ConfirmationViewController"
    case ProfileImageSelectViewController = "ProfileImageSelectViewController"
    case SampleImageSelectViewController = "SampleImageSelectViewController"

    var name: String {
        return self.rawValue
    }
}
