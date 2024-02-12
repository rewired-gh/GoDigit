import SwiftUI

class __ViewModel: ObservableObject {
  @Published var inputText: String = "" {
    didSet {
      debugPrint("Hello world")
    }
  }
}

struct __View: View {
  @ObservedObject var model = __ViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 25) {
        SectionView(title: "__", icon: "__") {
          HStack {
            TextField("__", text: $model.inputText)
              .textFieldStyle(RoundedBorderTextFieldStyle())
          }
        }
      }
      .padding()
      .navigationTitle("__")
    }
    .tint(.green)
  }
}

#Preview {
  __View()
}
