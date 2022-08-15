import SwiftUI
import Utility

public struct AsyncImage<ImageView: View, Placeholder: View, Loader: ImageLoaderProtocol>: View {
    @ObservedObject
    private var loader: Loader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> ImageView

    public init(
        loader: Loader,
        placeholder: Placeholder,
        configuration: @escaping (Image) -> ImageView
    ) {
        self.placeholder = placeholder
        self.configuration = configuration
        self.loader = loader
    }

    public var body: some View {
        switch loader.state {
            case .loading, .initial:
                placeholder
                    .onAppear(perform: loader.load)
                    .onDisappear(perform: loader.cancel)
            case let .loaded(image):
                configuration(Image(uiImage: image))
            case .failed:
                Color.red
        }
    }
}

// MARK: - Previews

// swiftlint:disable force_unwrapping
struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsyncImage(
                loader: ImageLoader(
                    url: URL(string: "https://thispersondoesnotexist.com/image")!
                ),
                placeholder: Text("Loading…"),
                configuration: { $0 }
            )
        }
    }
}
