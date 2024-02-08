import SwiftUI

struct NumberField: View {
  @Binding var value: Int
  let maxValue: NSNumber
  let prompt: String
  let numberFormatter: NumberFormatter

  init(value: Binding<Int>, maxValue: NSNumber, prompt: String) {
    _value = value
    self.maxValue = maxValue
    self.prompt = prompt
    numberFormatter = {
      let nf = NumberFormatter()
      nf.numberStyle = .decimal
      nf.maximum = maxValue
      nf.minimum = 0
      return nf
    }()
  }

  var body: some View {
    TextField(prompt, value: $value, formatter: numberFormatter)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .keyboardType(.numberPad)
      .autocorrectionDisabled()
      .autocapitalization(.none)
  }
}

#Preview {
  @State var value: Int = 0
  return NumberField(value: $value, maxValue: 512, prompt: "Hello")
}
