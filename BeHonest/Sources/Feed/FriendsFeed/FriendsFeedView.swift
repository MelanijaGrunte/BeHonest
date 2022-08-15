import ComposableArchitecture
import Foundation
import SwiftUI

public struct FriendsFeedView: View {
    let store: Store<FriendsFeedState, FriendsFeedAction>

    public init(
        store: Store<FriendsFeedState, FriendsFeedAction>
    ) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            varyingBody
                .onAppear(perform: {
                    viewStore.send(.onAppear)
                })
        }
    }

    public var varyingBody: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.viewState {
                case .loading:
                    Text("Loading…")
                case let .loaded(answers):
                    loadedView(answers: answers)
            }
        }
    }

    public func loadedView(answers: [HonestAnswer]) -> some View {
        List {
            ForEach(answers) { answer in
                FriendHonestyView(honestAnswer: answer)
            }
        }
        .navigationTitle(Text("BeHonest"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addAnswerButton
            }
        }
    }

    var addAnswerButton: some View {
        WithViewStore(store) { viewStore in
            Button(
                action: {
                    viewStore.send(.onAnswerTapped)
                },
                label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(Color.white)
                }
            )
        }
    }
}

struct FriendHonestyView: View {
    let honestAnswer: HonestAnswer

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center  , spacing: 5) {
                AsyncImage(
                    url: URL(string: "https://thispersondoesnotexist.com/image"),
                    content: { image in
                        image
                            .resizable()
                            .frame(width: 24, height: 24, alignment: .center)
                    },
                    placeholder: {
                        Image.init(systemName: "person.fill.viewfinder")
                    }
                )
                .frame(width: 24, height: 24, alignment: .center)

                Text(honestAnswer.author.name)
                Text("(\(honestAnswer.minutesLate))")
                    .font(.caption2)
            }

            Text(honestAnswer.question)
                .font(.caption2)
            Text(honestAnswer.answer)
                .font(.body)
        }
        .padding(.vertical, 10)
    }
}

//struct FriendsFeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsFeedView()
//    }
//}
