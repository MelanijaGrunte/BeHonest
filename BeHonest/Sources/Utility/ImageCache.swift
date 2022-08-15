import UIKit

public struct ImageCache {
    public static let shared = ImageCache()

    public func get(for key: URL) -> UIImage? {
        cache.object(forKey: key as NSURL)
    }

    public func set(image: UIImage?, for key: URL) {
        if let image = image {
            cache.setObject(image, forKey: key as NSURL)
        } else {
            cache.removeObject(forKey: key as NSURL)
        }
    }

    // MARK: Private

    private let cache = NSCache<NSURL, UIImage>()
}
