import UIKit

typealias ImageLoadOperationCompletionHandlerType = ((UIImage) -> Void)?

class ImageLoadOperation: Operation {
    var url: String
    var completionHandler: ImageLoadOperationCompletionHandlerType
    var image: UIImage?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        UIImage.donwloadImageFromUrl(url: url) { [weak self] image in
            guard let strongSelf = self,
                let image = image else {
                    return
            }
            strongSelf.image = image
            strongSelf.completionHandler?(image)
        }
    }
}
