import BigInt
import Foundation

enum Radix: String, CaseIterable, Identifiable {
  case dec, hex, oct, bin
  var id: Self { self }
  var letter: String {
    switch self {
    case .dec:
      return "d"
    case .hex:
      return "h"
    case .oct:
      return "o"
    case .bin:
      return "b"
    }
  }

  var number: Int {
    switch self {
    case .dec:
      return 10
    case .hex:
      return 16
    case .oct:
      return 8
    case .bin:
      return 2
    }
  }
}

enum NumberKind: String, CaseIterable, Identifiable {
  case math, signed, unsigned
  var id: Self { self }
}

enum FloatPrecision: String, CaseIterable, Identifiable {
  case single, double
  var id: Self { self }
}

func stringToBigInt(str: String, radix: Radix, width: Int, kind: NumberKind) -> BigInt? {
  if str.isEmpty {
    return nil
  }
  let tmp = BigInt(str, radix: radix.number)
  if tmp == nil {
    return nil
  }
  var num = tmp!
  if kind != .math, num.sign == .minus {
    return nil
  }
  if num.bitWidth > width + 1 {
    return nil
  }
  if kind == .math, num != -(BigInt(1) << (width - 1)), num.bitWidth > width {
    return nil
  }
  if kind == .signed, num.bitWidth == width + 1 {
    num = -(BigInt(calculateTwoComp(str: String(num, radix: 2)), radix: 2)!)
  }
  return num
}

func calculateTwoComp(str: String) -> String {
  var tmp = Array(str)
  for i in tmp.indices {
    let char = tmp[i]
    if char == "0" {
      tmp[i] = "1"
    } else {
      tmp[i] = "0"
    }
  }
  for i in tmp.indices.reversed() {
    let char = tmp[i]
    if char == "0" {
      tmp[i] = "1"
      break
    } else {
      tmp[i] = "0"
    }
  }
  return String(tmp)
}

extension BigInt {
  func toComputerBin(width: Int) -> String {
    var tmp = String(magnitude, radix: 2)
    if sign == .minus {
      tmp = calculateTwoComp(str: tmp)
      tmp = String(repeating: "1", count: width - tmp.count) + tmp
    }
    return tmp
  }

  func toComputerHex(width: Int) -> String {
    let tmp = BigInt(toComputerBin(width: width), radix: 2)!
    return String(tmp, radix: 16)
  }
}
