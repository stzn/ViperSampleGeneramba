import UIKit

final class ProfileImageSelectViewController: UIViewController {

    // MARK: - Public properties -

    var presenter: ProfileImageSelectPresenterInterface!

    @IBOutlet weak var selectedImageView: UIImageView!
    
    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "画像選択"
        let backButton = UIBarButtonItem(title: "戻る", style:  .plain, target: self, action: #selector(backBarButtonTapped))
        
        let barButton = UIBarButtonItem(title: "次へ", style:  .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = barButton

        self.navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: - Extensions -


// MARK: - UserInteraction -
extension ProfileImageSelectViewController {

    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        selectPhotoAction()
    }
    
    @IBAction func selectSampleButtonTapped(_ sender: Any) {
        presenter.selectSampleButtonTapped()
    }

    @objc func rightBarButtonTapped(_ sender: Any) {
        
        guard let image = selectedImageView.image else { return }
        presenter.confirmButtonTapped(image: image)
    }
    @objc func backBarButtonTapped(_ sender: Any) {
        presenter.backButtonTapped()
    }
}

extension ProfileImageSelectViewController {
    
    private func selectPhotoAction() {
        
        let alert = UIAlertController(title: "写真を選ぶ", message: "写真の選択方法を決めてください", preferredStyle: .actionSheet)
        
        let takePhotoLibrary = UIAlertAction(title: "撮影する", style: .default) { [unowned self] action in
            self.showCameraPicker(sourceType: .camera)
        }
        
        let openLibraryAction = UIAlertAction(title: "ライブラリを開く", style: .default) { [unowned self] action in
            self.showCameraPicker(sourceType: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            
        }
        
        alert.addAction(takePhotoLibrary)
        alert.addAction(openLibraryAction)
        alert.addAction(cancel)

        self.present(alert, animated: true)
    }
    
    private func showCameraPicker(sourceType: UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }
}

extension ProfileImageSelectViewController: ProfileImageSelectViewInterface {
}

extension ProfileImageSelectViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.ProfileImageSelectViewController.name
    }
}

extension ProfileImageSelectViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
