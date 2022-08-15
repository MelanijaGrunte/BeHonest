import Foundation
import SwiftUI
import Feed
import Combine

class ShareHonestyHostingViewController: UIHostingController<ShareHonestyView> {
    init(
        onClose: @escaping (String) -> Void
    ) {
        let rootView = ShareHonestyView(
            store: .init(
                initialState: .init(),
                reducer: shareHonestyReducer,
                environment: .init(
                    provider: .live,
                    mainQueue: .main,
                    errorPublisher: .noop,
                    onClose: onClose
                )
            )
        )

        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShareHonestyProvider {
    static let live: ShareHonestyProvider = .init(share: { honestAnswer in
        return Just(.success(())).eraseToAnyPublisher()
    })
}
