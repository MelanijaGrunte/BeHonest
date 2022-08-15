import Combine
import UIKit

public protocol ImageLoaderProtocol: ObservableObject {
    var state: ImageLoader.State { get }

    func load()
    func cancel()
}

public class ImageLoader: ImageLoaderProtocol, Equatable {
    public static func == (lhs: ImageLoader, rhs: ImageLoader) -> Bool {
        lhs.url == rhs.url && lhs.state == rhs.state
    }

    @Published
    public var state: State = .initial
    private var disposeBag = DisposeBag()
    private let url: URL?
    private var cache = ImageCache.shared

    public init(url: URL?) {
        if url == nil { state = .failed }
        self.url = url

        if let url = url, let image = cache.get(for: url) {
            state = .loaded(image)
        }

        load()
    }

    public func load() {
        guard case .initial = state else { return }

        guard let url = url else { return }

        if let image = cache.get(for: url) {
            state = .loaded(image)
            return
        }
        state = .loading

        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] in
                self?.cache($0, url: url)
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                        case .failure: self?.state = .failed
                        case .finished: break
                    }
                },
                receiveValue: { [weak self] image in
                    if let image = image {
                        self?.state = .loaded(image)
                    } else {
                        self?.state = .failed
                    }
                }
            )
            .store(in: &disposeBag)
    }

    public func cancel() {
        disposeBag.dispose()
        if case .loading = state {
            state = .initial
        }
    }

    private func cache(_ image: UIImage?, url: URL) {
        image.map {
            cache.set(image: $0, for: url)
        }
    }
}

public extension ImageLoader {
    enum State: Equatable {
        case initial
        case loading
        case loaded(UIImage)
        case failed
    }
}
