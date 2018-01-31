import UIKit

final class SampleImageSelectViewController: UIViewController {

    // MARK: - Public properties -

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: SampleImageSelectPresenterInterface!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "画像選択"
        let backButton = UIBarButtonItem(title: "キャンセル", style:  .plain, target: self, action: #selector(backBarButtonTapped))
        
        self.navigationItem.leftBarButtonItem = backButton
    }    
}

// MARK: - Extensions -

// MARK: - Setup -
extension SampleImageSelectViewController {
    
    private func _setupUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UserInteraction -
extension SampleImageSelectViewController {
    
    @objc func backBarButtonTapped(_ sender: Any) {
        presenter.backButtonTapped()
    }
}

extension SampleImageSelectViewController: SampleImageSelectViewInterface {
}

extension SampleImageSelectViewController: StoryboardLoadable {
    static var storyboardName: String {
        return Storyboard.SampleImageSelectViewController.name
    }
}

extension SampleImageSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let image = presenter.item(at: indexPath.row) ?? UIImage()
        presenter.didSelectImage(image: image)
    }
}

extension SampleImageSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numerOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
        let image = presenter.item(at: indexPath.row)
        cell.imageView.image = image
        return cell
    }
}

