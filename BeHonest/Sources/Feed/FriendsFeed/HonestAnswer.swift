import Foundation

public struct HonestAnswer: Equatable, Identifiable {
    public var id: String { author.name + datePublished.ISO8601Format() }
    
    let author: Friend
    let question: String
    var answer: String
    public let dateRequested: Date
    let datePublished: Date

    var minutesLate: String {
        let minutes = Calendar.current.dateComponents([.minute], from: dateRequested, to: datePublished).minute ?? 0
        return "\(minutes) minutes late"
    }

    public mutating func setAnswer(_ answer: String) {
        self.answer = answer
    }

    public init(
        author: Friend,
        question: String,
        answer: String,
        dateRequested: Date,
        datePublished: Date
    ) {
        self.author = author
        self.question = question
        self.answer = answer
        self.dateRequested = dateRequested
        self.datePublished = datePublished
    }
}
