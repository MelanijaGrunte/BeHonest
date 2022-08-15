import Foundation
import SwiftUI
import Feed
import Combine
import Utility

class FriendsFeedHostingViewController: UIHostingController<FriendsFeedView> {
    init(
        onAnswersTapped: @escaping () -> Void
    ) {
        UserDefaultsManager.shared.remove(forKey: .firstQuestionAnswer)

        let rootView = FriendsFeedView(
            store: .init(
                initialState: .init(),
                reducer: friendsFeedReducer,
                environment: .init(
                    provider: .live,
                    client: .live,
                    mainQueue: .main,
                    errorPublisher: .noop,
                    onAnswerTapped: onAnswersTapped
                )
            )
        )

        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HonestAnswerProvider {
    static let live: HonestAnswerProvider = HonestAnswerProvider(getAnswers: { albumNames in
        let friendAnswers = HonestAnswerDataSource.all

        let savedInput = UserDefaultsManager.shared.string(forKey: .firstQuestionAnswer)
        var honestAnswers = [HonestAnswer]()
        if let savedInput = savedInput {
            honestAnswers.append(
                .init(
                    author: .init(name: "Melānija"),
                    question: .firstQuestion,
                    answer: savedInput,
                    dateRequested: friendAnswers.first?.dateRequested ?? Date(),
                    datePublished: Date()
                )
            )
        }

        var modifiedFriendAnswers = [HonestAnswer]()
        for i in (0 ..< friendAnswers.count) {
            if var answer = friendAnswers.get(i), let albumTitle = albumNames.get(i) {
                answer.setAnswer(albumTitle)
                modifiedFriendAnswers.append(answer)
            }
        }

        honestAnswers.append(contentsOf: modifiedFriendAnswers)

        return Just(.success(honestAnswers)).eraseToAnyPublisher()
    })
}

private extension Array {
    func get(_ index: Int) -> Element? {
        if count <= index || index < 0 { return nil }
        return self[index]
    }
}
