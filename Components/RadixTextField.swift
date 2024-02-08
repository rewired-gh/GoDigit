import SwiftUI

struct RadixTextField: View {
  @Binding var radix: Radix
  @Binding var width: Int
  @Binding var text: String
  var leadingText: String {
    if width > 0 {
      String(width) + "'" + radix.letter
    } else {
      "'" + radix.letter
    }
  }

  var body: some View {
    HStack {
      Text(leadingText)
      TextField("Enter a number", text: $text)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocorrectionDisabled()
        .autocapitalization(.none)
    }
    .font(.system(.body, design: .monospaced))
  }
}
