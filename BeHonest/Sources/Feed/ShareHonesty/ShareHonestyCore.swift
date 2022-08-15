import ComposableArchitecture
import DesignSystem
import Utility

public struct ShareHonestyState: Equatable {
    var input: String = ""

    public init() {}
}

public enum ShareHonestyAction {
    case onAppear
    case inputChanged(String)
    case onSubmit
    case onAnswerSubmitted(Result<Void, Error>)
}

public struct ShareHonestyEnvironment {
    let provider: ShareHonestyProvider
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let errorPublisher: ErrorHandlerPublisher
    let onClose: (String) -> Void

    public init(
        provider: ShareHonestyProvider,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        errorPublisher: ErrorHandlerPublisher,
        onClose: @escaping (String) -> Void
    ) {
        self.provider = provider
        self.mainQueue = mainQueue
        self.errorPublisher = errorPublisher
        self.onClose = onClose
    }
}

public let shareHonestyReducer = Reducer<
    ShareHonestyState,
    ShareHonestyAction,
    ShareHonestyEnvironment
>.combine(
    Reducer { state, action, environment in
        switch action {
            case .onAppear:
                return .none

            case let .inputChanged(input):
                state.input = input
                return .none

            case .onSubmit:
                let honestAnswer = HonestAnswer(
                    author: .init(name: "Melānija"),
                    question: .firstQuestion,
                    answer: state.input,
                    dateRequested: Date(),
                    datePublished: Date()
                )

                return environment.provider.share(honestAnswer)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect(ShareHonestyAction.onAnswerSubmitted)

            case .onAnswerSubmitted(.success):
                environment.onClose(state.input)
                return .none

            case let .onAnswerSubmitted(.failure(error)):
                environment.errorPublisher.send(.snackbar(error))
                return .none
        }
    }
)
