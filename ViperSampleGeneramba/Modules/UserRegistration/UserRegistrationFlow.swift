import UIKit

/// User Registration Flow
struct UserRegistrationFlow {

    static func startUserRegistration(on viewController: UIViewController) {
        
        let navigation  = UINavigationController()
        enterPersonalStep(navigation).perform(()) { personal in
            
            guard let personal = personal else {
                viewController.dismiss(animated: true)
                return
            }
            
            enterLoginStep(navigation).perform(()) { account in
                
                guard let account = account else {
                    navigation.popViewController(animated: true)
                    return
                }
                
                SetProfileImageStep.startSetProfileImage(navigation) { image in
                    
                    let user = UserRegistration(personal: personal, account: account, profileImage: image)
                    enterConfirmStep(navigation).perform(user) { result in
                        
                        if result == nil {
                            navigation.popViewController(animated: true)
                            return
                        }
                        viewController.dismiss(animated: true)
                    }
                }
            }
        }
        viewController.present(navigation, animated: true)
    }
    
    private static func enterPersonalStep(_ navigation: UINavigationController) -> StepT<Void, PersonalInformation?> {
        return StepT(PersonalWireframe(navigation: navigation))
    }
    
    private static func enterLoginStep(_ navigation: UINavigationController) -> StepT<Void, AccountInformation?> {
        return StepT(AccountWireframe(navigation: navigation))
    }
    
    private static func enterConfirmStep(_ navigation: UINavigationController) -> StepT<UserRegistration, Bool?>  {
        return StepT(ConfirmationWireframe(navigation: navigation))
    }
    
}


/// Register Profile Image Step
enum ProfileImageType {
    case own(UIImage)
    case sample
    
}

struct SetProfileImageStep {
    
    static func startSetProfileImage(_ navigation: UINavigationController, complete: @escaping (UIImage) -> Void) {
        
        profileImageSelectStep(navigation).perform(()) { result in
            
            guard let result = result else {
                navigation.popViewController(animated: true)
                return
            }
            
            switch result {
            
            case let .own(image):
                complete(image)
            
            case .sample:
                
                sampleImageSelectStep(navigation).perform(()) { image in
                    guard let image = image else {
                        navigation.popViewController(animated: true)
                        return
                    }
                    complete(image)
                }
            }
        }
    }
    
    private static func profileImageSelectStep(_ navigation: UINavigationController) -> StepT<Void, ProfileImageType?>  {
        return StepT(ProfileImageSelectWireframe(navigation: navigation))
    }
    
    private static func sampleImageSelectStep(_ navigation: UINavigationController) -> StepT<Void, UIImage?>  {
        return StepT(SampleImageSelectWireframe(navigation: navigation))
    }
}
