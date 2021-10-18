import Foundation
import UIKit

class ImageProvider {
    typealias Handle = UUID
    typealias ImageRequestResult = (UIImage?) -> Void

    static let shared = ImageProvider()
    private let cache = NSCache<NSString, UIImage>()
    private var handles: Set<UUID> = .init()

    private init() {}

    func getImage(for urlString: String?, completion: @escaping ImageRequestResult) -> Handle? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return nil
        }
        if let image = cache.object(forKey: NSString(string: urlString)) {
            completion(image)
            return nil
        } else {
            let uuid = UUID()
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    completion(nil)
                    self.handles.remove(uuid)
                    return
                }
                let image = UIImage(data: data)
                if self.handles.contains(uuid) {
                    DispatchQueue.main.async { completion(image) }
                    self.handles.remove(uuid)
                }
                if let image = image {
                    self.cache.setObject(image, forKey: NSString(string: urlString))
                }
            }.resume()
            return uuid
        }
    }

    func cancel(handle: Handle?) {
        guard let handle = handle else { return }
        handles.remove(handle)
    }
}
