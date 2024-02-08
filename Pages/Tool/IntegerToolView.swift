import BigInt
import SwiftUI

class IntegerToolViewModel: ObservableObject {
  @Published var inputRadix: Radix = .dec
  @Published var inputKind: NumberKind = .math
  @Published var inputWidthExponent: Double = 5 {
    didSet {
      inputWidth = 1 << Int(inputWidthExponent)
    }
  }

  @Published var inputWidth: Int = 32
  @Published var inputValueString: String = ""
  var inputBigInt: BigInt? {
    stringToBigInt(
      str: inputValueString.replacingOccurrences(of: "_", with: ""),
      radix: inputRadix,
      width: inputWidth,
      kind: inputKind
    )
  }

  var outputNatrualDec: String {
    if inputBigInt != nil {
      String(inputBigInt!)
    } else {
      "Unavailable"
    }
  }

  var outputComputerBin: String {
    if inputBigInt != nil {
      inputBigInt!.toComputerBin(width: inputWidth)
    } else {
      "Unavailable"
    }
  }

  var outputComputerHex: String {
    if inputBigInt != nil {
      inputBigInt!.toComputerHex(width: inputWidth)
    } else {
      "Unavailable"
    }
  }

  var outputNatrualHex: String {
    if inputBigInt != nil {
      String(inputBigInt!, radix: 16)
    } else {
      "Unavailable"
    }
  }
}

struct IntegerToolView: View {
  @ObservedObject var model = IntegerToolViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 25) {
        SectionView(title: "Input number traits", icon: "number.circle") {
          Picker("Input radix", selection: $model.inputRadix) {
            ForEach(Radix.allCases) { item in
              Text(item.rawValue.capitalized)
            }
          }.pickerStyle(SegmentedPickerStyle())
          Picker("Input kind", selection: $model.inputKind) {
            ForEach(NumberKind.allCases) { item in
              Text(item.rawValue.capitalized)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }
        SectionView(title: "Input number width (bits)", icon: "ruler") {
          HStack {
            Slider(value: $model.inputWidthExponent,
                   in: 2 ... 7,
                   step: 1,
                   minimumValueLabel: Text("4"),
                   maximumValueLabel: Text("128"),
                   label: {
                     Text("Input width exponent")
                   })
            NumberField(value: $model.inputWidth, maxValue: 512, prompt: "Width")
              .frame(maxWidth: 70)
          }
        }
        SectionView(title: "Input value", icon: "equal.circle") {
          RadixTextField(radix: $model.inputRadix, width: $model.inputWidth, text: $model.inputValueString) {}
        }
        Divider()
        Label("Tips: Outputs are selectable", systemImage: "lightbulb")
          .labelStyle(.automatic)
          .foregroundStyle(.secondary)
          .font(.footnote)
          .padding(.vertical, -5)
        SectionView(title: "Output: Math decimal", icon: "function") {
          Text(model.outputNatrualDec)
            .padding(.top, 2)
            .font(.system(.body, design: .monospaced))
            .textSelection(.enabled)
        }
        SectionView(title: "Output: Computer binary", icon: "function") {
          Text(model.outputComputerBin)
            .padding(.top, 2)
            .font(.system(.body, design: .monospaced))
            .textSelection(.enabled)
        }
        SectionView(title: "Output: Computer hexadecimal", icon: "function") {
          Text(model.outputComputerHex)
            .padding(.top, 2)
            .font(.system(.body, design: .monospaced))
            .textSelection(.enabled)
        }
        SectionView(title: "Output: Math hexadecimal", icon: "function") {
          Text(model.outputNatrualHex)
            .padding(.top, 2)
            .font(.system(.body, design: .monospaced))
            .textSelection(.enabled)
        }
      }
      .frame(
        maxWidth: .infinity,
        alignment: .topLeading
      )
      .padding()
      .navigationTitle("Integer converter")
    }
    .tint(.green)
  }
}

#Preview {
  IntegerToolView()
}
