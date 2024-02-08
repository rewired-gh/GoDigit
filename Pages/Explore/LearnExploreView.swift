import SwiftUI

struct LearnExploreView: View {
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.flexible())]) {
          NavigationLink(destination: LearnRadixView()) {
            CardView(
              title: "Number and radix",
              description: "Learn what is a radix and how to convert between radices. It covers three commonly-used radices.",
              color: .cyan
            )
          }
          NavigationLink(destination: LearnIntegerView()) {
            CardView(
              title: "Integer in computer",
              description: "Learn how integer numbers are stored in computers. It covers the basics of two's complement.",
              color: .accentColor
            )
          }
          CardView(
            title: "Coming soon...",
            description: "Thank you for using this app! I'm working hard to bring you more learning resources. Stay tuned and thanks for your patience.",
            color: .gray
          )
          .opacity(0.8)
        }
      }
      .padding()
      .navigationTitle("Learn")
    }
  }
}

#Preview {
  LearnExploreView()
}
