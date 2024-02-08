import SwiftUI

struct CardView: View {
  let title: String
  let description: String
  let color: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(self.title)
        .font(.system(size: 22))
        .fontWeight(.medium)
        .foregroundStyle(self.color)
      Text(self.description)
        .font(.subheadline)
        .foregroundStyle(.gray)
        .multilineTextAlignment(.leading)
    }
    .padding()
    .frame(maxWidth: .infinity, minHeight: 130, maxHeight: 130, alignment: .leading)
    .background(color.opacity(0.15))
    .cornerRadius(15)
  }
}

#Preview {
  CardView(title: "Lorem ipsum", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce bibendum eros placerat, egestas ex eu, maximus nisi. Praesent at est at tellus ultrices cursus in eu massa. Aenean facilisis lectus ut lobortis pharetra.", color: .accentColor)
}
