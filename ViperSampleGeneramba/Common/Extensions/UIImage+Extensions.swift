import UIKit

extension UIImage {
    
    static func donwloadImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
            }
            completion(image)
        }
        task.resume()
    }
}
