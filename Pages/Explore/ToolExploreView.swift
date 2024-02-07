import SwiftUI

struct ToolExploreView: View {
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: [GridItem(.flexible())]) {
          NavigationLink(destination: IntegerToolView()) {
            CardView(
              title: "Integer converter",
              description: "Convert integer number to other forms. It is useful for exploring how integer numbers are stored in computers.",
              color: .green
            )
          }
          CardView(
            title: "Coming soon...",
            description: "Thank you for using this app! I'm working hard to bring you more tools and features. Stay tuned and thank you for your patience.",
            color: .gray
          )
          .opacity(0.8)
        }
      }
      .padding()
      .navigationTitle("Tools")
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

#Preview {
  ToolExploreView()
}
