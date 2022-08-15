import SwiftUI
import ComposableArchitecture

public struct ShareHonestyView: View {
    let store: Store<ShareHonestyState, ShareHonestyAction>

    public init(
        store: Store<ShareHonestyState, ShareHonestyAction>
    ) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    Text(String.firstQuestion)

                    TextEditor(
                        text: viewStore.binding(
                            get: \.input,
                            send: ShareHonestyAction.inputChanged
                        )
                    )
                    .frame(maxHeight: .infinity)
                    .multilineTextAlignment(.leading)
                    .background(Color.gray)

                    HStack {
                        Spacer()
                        Button(action: {
                            viewStore.send(.onSubmit)
                        }, label: {
                            Text("Submit")
                        })
                        Spacer()
                    }
                }
                .padding(24)
            }
        }
    }
}

//struct ShareHonestyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareHonestyView()
//    }
//}
