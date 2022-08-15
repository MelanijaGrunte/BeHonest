import Foundation

public struct HonestAnswerDataSource {
    static public let all: [HonestAnswer] = [
        .init(author: .init(
            name: "Margo"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(1))
        ),
        .init(author: .init(
            name: "Pēteris"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(534))
        ),
        .init(author: .init(
            name: "Gatis"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(643))
        ),
        .init(author: .init(
            name: "Evija"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(23))
        ),
        .init(author: .init(
            name: "Rūta"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(98))
        ),
        .init(author: .init(
            name: "Ri4ons"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(1101))
        ),
        .init(author: .init(
            name: "Mare"),
              question: .firstQuestion,
              answer: "",
              dateRequested: Date(),
              datePublished: Date().addingTimeInterval(TimeInterval(290))
        )
    ]
}

public extension String {
    static let firstQuestion: String = "What is your favourite music album?"
}
