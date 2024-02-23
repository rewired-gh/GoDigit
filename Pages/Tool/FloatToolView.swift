import SwiftUI

class FloatToolViewModel: ObservableObject {
  @Published var precision: FloatPrecision = .double
  @Published var inputNumberString = ""

  var numberFloat: Float? {
    return Float(inputNumberString)
  }

  var numberDouble: Double? {
    return Double(inputNumberString)
  }

  var numberSign: FloatingPointSign? {
    switch precision {
    case .single:
      return numberFloat?.sign
    case .double:
      return numberDouble?.sign
    }
  }

  var numberExponent: UInt? {
    switch precision {
    case .single:
      return numberFloat?.exponentBitPattern
    case .double:
      return numberDouble?.exponentBitPattern
    }
  }

  var numberFraction: UInt64? {
    switch precision {
    case .single:
      guard numberFloat != nil else {
        return nil
      }
      return UInt64(numberFloat!.significandBitPattern)
    case .double:
      return numberDouble?.significandBitPattern
    }
  }

  var outputValueString: String {
    switch precision {
    case .single:
      guard numberFloat != nil else {
        return "Unavailable"
      }
      return String(numberFloat!)
    case .double:
      guard numberDouble != nil else {
        return "Unavailable"
      }
      return String(numberDouble!)
    }
  }

  var signBitString: String {
    switch numberSign {
    case .plus:
      "0"
    case .minus:
      "1"
    case nil:
      "Unavailable"
    }
  }

  var exponentHexString: String {
    guard numberExponent != nil else {
      return "Unavailable"
    }
    let str = String(numberExponent!, radix: 16)
    switch precision {
    case .single:
      return str.leftPad(with: "0", toLength: 2)
    case .double:
      return str.leftPad(with: "0", toLength: 3)
    }
  }

  var exponentDecString: String {
    guard numberExponent != nil else {
      return "Unavailable"
    }
    return String(numberExponent!)
  }

  var exponentShiftedDecString: String {
    guard numberExponent != nil else {
      return "Unavailable"
    }
    switch precision {
    case .single:
      return String(Int(numberExponent!) - 127)
    case .double:
      return String(Int(numberExponent!) - 1023)
    }
  }

  var fractionHexString: String {
    guard numberFraction != nil else {
      return "Unavailable"
    }
    let str = String(numberFraction!, radix: 16)
    switch precision {
    case .single:
      return str.leftPad(with: "0", toLength: 6)
    case .double:
      return str.leftPad(with: "0", toLength: 13)
    }
  }

  var fractionBinString: String {
    guard numberFraction != nil else {
      return "Unavailable"
    }
    let str = String(numberFraction!, radix: 2)
    switch precision {
    case .single:
      return "1." + str.leftPad(with: "0", toLength: 23)
    case .double:
      return "1." + str.leftPad(with: "0", toLength: 52)
    }
  }
}

struct FloatToolView: View {
  @ObservedObject var model = FloatToolViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 25) {
        SectionView(title: "Number precision", icon: "ruler") {
          Picker("Number precision", selection: $model.precision) {
            ForEach(FloatPrecision.allCases) { item in
              Text(item.rawValue.capitalized)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }
        SectionView(title: "Input value", icon: "equal.circle") {
          TextField("Input value", text: $model.inputNumberString)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .submitLabel(.done)
        }
        SectionView(title: "Output: Value", icon: "function") {
          Text(model.outputValueString)
            .textSelection(.enabled)
            .padding(.top, 2)
        }
        SectionView(title: "Output: Sign bit", icon: "function") {
          HStack(spacing: 0) {
            Text("Bin: ")
            Text(model.signBitString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
        }
        SectionView(title: "Output: Exponent", icon: "function") {
          HStack(spacing: 0) {
            Text("Hex (raw): ")
            Text(model.exponentHexString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
          HStack(spacing: 0) {
            Text("Dec (raw): ")
            Text(model.exponentDecString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
          HStack(spacing: 0) {
            Text("Dec (shifted): ")
            Text(model.exponentShiftedDecString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
        }
        SectionView(title: "Output: Fraction", icon: "function") {
          HStack(spacing: 0) {
            Text("Hex (raw): ")
            Text(model.fractionHexString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
          HStack(spacing: 0) {
            Text("Bin: ")
            Text(model.fractionBinString)
              .textSelection(.enabled)
          }
          .padding(.top, 2)
          .font(.system(.body, design: .monospaced))
        }
      }
      .padding()
      .navigationTitle("Float inspector")
    }
    .tint(.purple)
  }
}

#Preview {
  FloatToolView()
}
