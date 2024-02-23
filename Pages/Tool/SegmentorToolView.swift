import BigInt
import SwiftUI

struct Segment: Identifiable, Codable {
  var id = UUID()
  var start: Int
  var end: Int
  var label: String
}

struct SegmentOutput: Identifiable {
  let id = UUID()
  let range: String
  let label: String
  let hex: String
  let dec: String
  let bin: String
}

struct Preset: Identifiable, Codable {
  var id = UUID()
  var name: String
  var segments: [Segment]
}

class SegmentorToolViewModel: ObservableObject {
  @Published var inputRadix: Radix = .dec
  @Published var segments: [Segment] = []
  @Published var inputValueString = ""
  @Published var segmentOutputs: [SegmentOutput] = []
  var isCanCalculate = true
  @Published var isPresetsSheetPresent = false
  @AppStorage("BitsExtractorPresets") var presets: [Preset] = [
    Preset(name: "IEEE 754-2008 32 bits", segments: [
      Segment(start: 31, end: 31, label: "Sign"),
      Segment(start: 23, end: 30, label: "Exponent"),
      Segment(start: 0, end: 22, label: "Fraction"),
    ]),
    Preset(name: "IEEE 754-2008 64 bits", segments: [
      Segment(start: 63, end: 63, label: "Sign"),
      Segment(start: 52, end: 62, label: "Exponent"),
      Segment(start: 0, end: 51, label: "Fraction"),
    ]),
    Preset(name: "RISC-V R-type Instruction", segments: [
      Segment(start: 0, end: 6, label: "opcode"),
      Segment(start: 7, end: 11, label: "rd"),
      Segment(start: 12, end: 14, label: "funct3"),
      Segment(start: 15, end: 19, label: "rs1"),
      Segment(start: 10, end: 24, label: "rs2"),
      Segment(start: 25, end: 31, label: "funct7"),
    ]),
    Preset(name: "RISC-V Sv48 PTE", segments: [
      Segment(start: 0, end: 0, label: "V"),
      Segment(start: 1, end: 1, label: "R"),
      Segment(start: 2, end: 2, label: "W"),
      Segment(start: 3, end: 3, label: "X"),
      Segment(start: 4, end: 4, label: "U"),
      Segment(start: 5, end: 5, label: "G"),
      Segment(start: 6, end: 6, label: "A"),
      Segment(start: 7, end: 7, label: "D"),
      Segment(start: 8, end: 9, label: "RSW"),
      Segment(start: 10, end: 18, label: "PPN[0]"),
      Segment(start: 19, end: 27, label: "PPN[1]"),
      Segment(start: 28, end: 36, label: "PPN[2]"),
      Segment(start: 37, end: 53, label: "PPN[3]"),
      Segment(start: 54, end: 60, label: "(Reserved)"),
      Segment(start: 61, end: 62, label: "PBMT"),
      Segment(start: 63, end: 63, label: "N"),
    ]),
  ]
  @Published var newPresetName = ""
  @Published var isInvalidNameAlertPresent = false

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
        dec: String(tmp ?? 0),
        bin: String(tmp ?? 0, radix: 2).leftPad(with: "0", toLength: binWidth)
      ))
    }
    isCanCalculate = true
  }

  func togglePresetsSheet() {
    isPresetsSheetPresent = !isPresetsSheetPresent
  }

  func deletePreset(element: Preset) {
    let index = presets.firstIndex(where: { $0.id == element.id })
    guard index != nil else {
      return
    }
    presets.remove(at: index!)
  }

  func changeOrAddPreset() {
    guard !newPresetName.isEmpty else {
      isInvalidNameAlertPresent = true
      return
    }
    let index = presets.firstIndex(where: { $0.name == newPresetName })
    guard index != nil else {
      presets.append(Preset(name: newPresetName, segments: segments))
      return
    }
    presets[index!].segments = segments
  }
}

struct SegmentorToolView: View {
  @ObservedObject var model = SegmentorToolViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 25) {
        SectionView(title: "Segment definitions", icon: "square.and.pencil") {
          TextField("Preset name", text: $model.newPresetName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .submitLabel(.done)
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
              model.changeOrAddPreset()
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
                VStack(spacing: 5) {
                  HStack(spacing: 5) {
                    HStack(spacing: 0) {
                      Text("Hex: ")
                      Text(output.hex)
                        .textSelection(.enabled)
                      Spacer()
                    }
                    HStack(spacing: 0) {
                      Text("Dec: ")
                      Text(output.dec)
                        .textSelection(.enabled)
                      Spacer()
                    }
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
            model.togglePresetsSheet()
          }
        }
      }
    }
    .sheet(isPresented: $model.isPresetsSheetPresent) {
      VStack(spacing: 0) {
        ZStack {
          HStack {
            Spacer()
            Text("Presets")
              .font(.headline)
            Spacer()
          }
          HStack {
            Spacer()
            Button(action: {
              model.togglePresetsSheet()
            }) {
              Text("Close")
            }
          }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        if model.presets.isEmpty {
          VStack {
            Spacer()
            Text("Presets list is empty")
              .font(.title2)
              .foregroundStyle(.secondary)
            Spacer()
          }
        } else {
          List(model.presets) { preset in
            HStack(spacing: 20) {
              Button(action: {
                model.newPresetName = preset.name
                model.segments = preset.segments
                model.togglePresetsSheet()
              }) {
                Text(preset.name)
                  .frame(maxWidth: .infinity, alignment: .topLeading)
              }
              .buttonStyle(.borderless)
              .foregroundStyle(.primary)
              Divider()
              Button(action: {
                model.deletePreset(element: preset)
              }) {
                Image(systemName: "trash")
                  .foregroundColor(.red)
              }
              .buttonStyle(.borderless)
            }
          }
        }
      }
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .topLeading
      )
    }
    .alert(
      "Invalid preset name",
      isPresented: $model.isInvalidNameAlertPresent,
      actions: {
        Button("OK", role: .cancel) {}
      }
    ) {
      Text("The current preset is unsaved. Please enter a valid preset name.")
    }
    .tint(.pink)
  }
}

#Preview {
  SegmentorToolView()
}
