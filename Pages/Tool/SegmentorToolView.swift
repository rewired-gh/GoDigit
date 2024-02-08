import BigInt
import SwiftUI

struct Segment: Identifiable {
  let id = UUID()
  var start: Int
  var end: Int
  var label: String
}

struct SegmentOutput: Identifiable {
  let id = UUID()
  let range: String
  let label: String
  let hex: String
  let bin: String
}

class SegmentorToolViewModel: ObservableObject {
  @Published var inputRadix: Radix = .dec {
    didSet {}
  }

  @Published var segments: [Segment] = []
  @Published var inputValueString = ""
  @Published var segmentOutputs: [SegmentOutput] = []
  var isCanCalculate = true

  func addNewSegment() {
    let newStartIdx = segments.isEmpty ? 0 : segments.last!.end + 1
    segments.append(Segment(start: newStartIdx, end: newStartIdx, label: ""))
  }

  func deleteSegment(element: Segment) {
    let index = segments.firstIndex(where: { $0.id == element.id })
    guard index != nil else {
      return
    }
    segments.remove(at: index!)
  }

  func calculateOutput() {
    segmentOutputs.removeAll()
    let tmp = BigInt(inputValueString, radix: inputRadix.number)
    if tmp == nil || tmp!.sign == .minus {
      isCanCalculate = false
      return
    }
    var binStr = String(tmp!, radix: 2)
    let n = binStr.count
    let maxN = (segments.map { $0.end }.max() ?? 0) + 1
    if maxN > n {
      binStr = String(repeating: "0", count: maxN - n) + binStr
    }
    for seg in segments {
      if seg.start > seg.end || seg.start >= binStr.count {
        segmentOutputs.removeAll()
        isCanCalculate = false
        return
      }
      let high = binStr.index(binStr.endIndex, offsetBy: -seg.start)
      let low = binStr.index(binStr.endIndex, offsetBy: -seg.end - 1)
      let tmp = BigInt(binStr[low ..< high], radix: 2)
      let binWidth = seg.end - seg.start + 1
      let hexWidth = (binWidth + 4 - 1) / 4
      segmentOutputs.append(SegmentOutput(
        range: "[\(seg.end), \(seg.start)]",
        label: seg.label,
        hex: String(tmp ?? 0, radix: 16).leftPad(with: "0", toLength: hexWidth),
        bin: String(tmp ?? 0, radix: 2).leftPad(with: "0", toLength: binWidth)
      ))
    }
    isCanCalculate = true
  }
}

struct SegmentorToolView: View {
  @ObservedObject var model = SegmentorToolViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 25) {
        SectionView(title: "Segment definitions", icon: "square.and.pencil") {
          Label("Tips: Each segment is defined by `[end:start]` (including start bit and end bit).", systemImage: "lightbulb")
            .labelStyle(.automatic)
            .foregroundStyle(.secondary)
            .font(.footnote)
            .padding(.vertical, 5)
          ForEach($model.segments) { $segment in
            HStack(spacing: 30) {
              HStack(spacing: 5) {
                Text("[")
                NumberField(value: $segment.end, maxValue: 512, prompt: "End")
                  .frame(minWidth: 50)
                Text(":")
                NumberField(value: $segment.start, maxValue: 512, prompt: "Start")
                  .frame(minWidth: 50)
                Text("]")
              }
              .font(.system(.body, design: .monospaced))
              TextField("Label", text: $segment.label)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .submitLabel(.done)
              Button(action: {
                model.deleteSegment(element: $segment.wrappedValue)
              }) {
                Image(systemName: "trash")
                  .foregroundColor(.red)
              }
            }
          }
          HStack {
            Button("Add segment", systemImage: "plus.circle") {
              model.addNewSegment()
            }
            .frame(maxWidth: .infinity)
            Button("Save as preset", systemImage: "square.and.arrow.down") {
              model.addNewSegment()
            }
            .frame(maxWidth: .infinity)
          }
          .padding(.top, 10)
        }
        SectionView(title: "Input radix", icon: "number.circle") {
          Picker("Input radix", selection: $model.inputRadix) {
            ForEach(Radix.allCases) { item in
              Text(item.rawValue.capitalized)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }
        SectionView(title: "Input value", icon: "equal.circle") {
          RadixTextField(radix: $model.inputRadix, width: Binding.constant(0), text: $model.inputValueString) {
            model.calculateOutput()
          }
        }
        Button("Calculate segments", systemImage: "wand.and.stars") {
          UIApplication.shared.endEditing()
          model.calculateOutput()
        }
        .frame(maxWidth: .infinity)
        SectionView(title: "Output segments", icon: "function") {
          VStack(spacing: 20) {
            ForEach(model.segmentOutputs) { output in
              VStack {
                HStack {
                  Text(output.range)
                  Spacer()
                  Text(output.label)
                }
                .lineLimit(1)
                .foregroundStyle(.secondary)
                Divider()
                VStack {
                  HStack(spacing: 0) {
                    Text("Hex: ")
                    Text(output.hex)
                      .textSelection(.enabled)
                    Spacer()
                  }
                  HStack(spacing: 0) {
                    Text("Bin: ")
                    Text(output.bin)
                      .textSelection(.enabled)
                    Spacer()
                  }
                }
                .font(.system(.body, design: .monospaced))
              }
            }
          }
          .padding(.top, 10)
          if !model.isCanCalculate {
            Label("Unable to calculate due to invalid input value or incorrect segment definitions.", systemImage: "exclamationmark.circle")
              .labelStyle(.automatic)
              .foregroundStyle(.secondary)
          }
        }
      }
      .frame(
        maxWidth: .infinity,
        alignment: .topLeading
      )
      .padding()
      .navigationTitle("Bits extractor")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Presets") {
            print("Presets tapped!")
          }
        }
      }
    }
    .tint(.pink)
  }
}

#Preview {
  SegmentorToolView()
}
