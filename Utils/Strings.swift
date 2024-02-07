import Foundation

extension String {
  func leftPad(with: Character, toLength: Int) -> String {
    let padCount = toLength - count
    guard padCount > 0 else { return self }
    return String(repeating: with, count: padCount) + self
  }
}
