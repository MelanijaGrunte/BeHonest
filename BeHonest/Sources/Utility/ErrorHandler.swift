import Combine

/// Publisher to pass errors back to error handler
public struct ErrorHandlerPublisher {
    public let publisher: AnyPublisher<ErrorHandlerType, Never>
    public let send: (ErrorHandlerType) -> Void

    public init(
        publisher: AnyPublisher<ErrorHandlerType, Never>,
        send: @escaping (ErrorHandlerType) -> Void
    ) {
        self.publisher = publisher
        self.send = send
    }
}

public extension ErrorHandlerPublisher {
    enum ErrorHandlerType {
        case snackbar(Error)
        case snackbarMessage(String)
    }
}

// MARK: - Previews

// Some demo error and implementation to use in Previews.
public extension ErrorHandlerPublisher {
    enum DemoError: Error {
        case demo
    }

    /// Demo ErrorHandlerPublisher for Previews
    static let noop = ErrorHandlerPublisher(
        publisher: Just(ErrorHandlerType.snackbar(DemoError.demo)).eraseToAnyPublisher(),
        send: { _ in }
    )
}
