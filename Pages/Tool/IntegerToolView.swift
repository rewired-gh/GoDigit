import BigInt
import SwiftUI

class IntegerToolViewModel: ObservableObject {
    @Published var inputRadix: Radix = .dec {
        didSet {
            updateInputLeading()
            calculate()
        }
    }

    @Published var inputKind: NumberKind = .math {
        didSet {
            calculate()
        }
    }

    @Published var inputWidthExponent: Double = 5 {
        didSet {
            inputWidth = 1 << Int(inputWidthExponent)
            inputWidthString = String(inputWidth)
            calculate()
        }
    }

    @Published var inputWidthString: String = "32" {
        didSet {
            let parsed: Int? = Int(inputWidthString)
            if parsed != nil && parsed! > 0 && parsed! <= 128 {
                inputWidth = parsed!
            } else {
                inputWidthString = String(inputWidth)
            }
            updateInputLeading()
            calculate()
        }
    }

    var inputWidth: Int = 32
    @Published var inputLeadingString: String = "32'd"
    @Published var inputValueString: String = "" {
        didSet {
            calculate()
        }
    }

    var inputBigInt: BigInt?
    @Published var outputNatrualDec: String = "Unavailable"
    @Published var outputComputerBin: String = "Unavailable"
    @Published var outputComputerHex: String = "Unavailable"
    @Published var outputNatrualHex: String = "Unavailable"

    func updateInputLeading() {
        inputLeadingString = inputWidthString + "'" + inputRadix.letter
    }

    func calculate() {
        inputBigInt = stringToBigInt(
            str: inputValueString.replacingOccurrences(of: "_", with: ""),
            radix: inputRadix,
            width: inputWidth,
            kind: inputKind
        )
        if inputBigInt != nil {
            let num = inputBigInt!
            outputNatrualDec = String(num)
            outputComputerBin = num.toComputerBin(width: inputWidth)
            outputComputerHex = num.toComputerHex(width: inputWidth)
            outputNatrualHex = String(num, radix: 16)
        } else {
            outputNatrualDec = "Unavailable"
            outputComputerBin = "Unavailable"
            outputComputerHex = "Unavailable"
            outputNatrualHex = "Unavailable"
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
                               in: 3 ... 6,
                               step: 1,
                               minimumValueLabel: Text("8"),
                               maximumValueLabel: Text("64"),
                               label: {
                                   Text("Input width exponent")
                               }
                        )
                        TextField("Width", text: $model.inputWidthString)
                            .frame(maxWidth: 70)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                SectionView(title: "Input value", icon: "equal.circle") {
                    HStack {
                        Text(model.inputLeadingString)
                        TextField("Enter a number", text: $model.inputValueString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .font(.system(.body, design: .monospaced))
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
            .padding()
            .navigationTitle("Integer converter")
        }
    }
}

#Preview {
    IntegerToolView()
}
