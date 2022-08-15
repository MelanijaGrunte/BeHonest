import ComposableArchitecture
import Utility

public enum FriendsFeedViewState: Equatable {
    case loading
    case loaded([HonestAnswer])
}

public struct FriendsFeedState: Equatable {
    var viewState: FriendsFeedViewState = .loading
    var initial = true

    public init() {}
}

public enum FriendsFeedAction {
    case onAppear
    case onTopAlbumsLoaded(Result<TopAlbums, Error>)
    case onAnswersLoaded(Result<[HonestAnswer], Error>)
    case onAnswerTapped
}

public struct FriendsFeedEnvironment {
    let provider: HonestAnswerProvider
    let client: Client
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let errorPublisher: ErrorHandlerPublisher
    let onAnswerTapped: () -> Void

    public init(
        provider: HonestAnswerProvider,
        client: Client,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        errorPublisher: ErrorHandlerPublisher,
        onAnswerTapped: @escaping () -> Void
    ) {
        self.provider = provider
        self.client = client
        self.mainQueue = mainQueue
        self.errorPublisher = errorPublisher
        self.onAnswerTapped = onAnswerTapped
    }
}

public let friendsFeedReducer = Reducer<
    FriendsFeedState,
    FriendsFeedAction,
    FriendsFeedEnvironment
>.combine(
    Reducer { state, action, environment in
        switch action {
            case .onAppear:
                // guard state.initial else { return .none }
                // state.initial = false

                return environment.client
                        .request(
                            ClientRequest(
                                method: "GET",
                                path: "2.0",
                                params: [
                                    "method": "user.gettopalbums",
                                    "user": "ajinalem",
                                    "period": "7day"
                                ]
                            )
                        )
                        .receive(on: environment.mainQueue)
                        .map { $0.map() }
                        .eraseToAnyPublisher()
                        .eraseToEffect()
                        .map(FriendsFeedAction.onTopAlbumsLoaded)

            case let .onTopAlbumsLoaded(.success(albums)):
                let albumNames = albums.albums.compactMap { $0.title }

                return environment.provider.getAnswers(albumNames)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect(FriendsFeedAction.onAnswersLoaded)

            case let .onTopAlbumsLoaded(.failure(error)):
                environment.errorPublisher.send(.snackbar(error))
                return .none

            case let .onAnswersLoaded(.success(answers)):
                state.viewState = .loaded(answers)
                return .none

            case let .onAnswersLoaded(.failure(error)):
                environment.errorPublisher.send(.snackbarMessage("Failed to load answers"))
                return .none

            case .onAnswerTapped:
                environment.onAnswerTapped()
                return .none
        }
    }
)
