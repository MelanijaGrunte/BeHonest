import Foundation
import Combine

public struct ShareHonestyProvider {
    var share: (HonestAnswer) -> AnyPublisher<Result<Void, Error>, Never>

    public init(
        share: @escaping (HonestAnswer) -> AnyPublisher<Result<Void, Error>, Never>
    ) {
        self.share = share
    }
}
