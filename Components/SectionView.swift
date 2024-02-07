import Foundation
import SwiftUI

struct SectionView<Content>: View where Content: View {
  let title: String
  let icon: String
  let content: Content

  init(title: String, icon: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.icon = icon
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading) {
      Label(title, systemImage: icon)
        .labelStyle(.automatic)
        .foregroundStyle(.secondary)
      content
    }
  }
}
