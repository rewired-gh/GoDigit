import SwiftUI

struct H2: View {
  let text: String

  init(_ text: String) {
    self.text = text
  }

  var body: some View {
    Text(text)
      .font(.system(size: 28))
      .fontWeight(.medium)
  }
}

#Preview {
  H2("Test")
}
