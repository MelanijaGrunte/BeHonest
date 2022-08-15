import Foundation
import Combine

public struct HonestAnswerProvider {
    var getAnswers: ([String]) -> AnyPublisher<Result<[HonestAnswer], Error>, Never>

    public init(
        getAnswers: @escaping ([String]) -> AnyPublisher<Result<[HonestAnswer], Error>, Never>
    ) {
        self.getAnswers = getAnswers
    }
}
