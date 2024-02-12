import SwiftUI

struct ToolExploreView: View {
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.flexible())]) {
          NavigationLink(destination: IntegerToolView()) {
            CardView(
              title: "Integer converter",
              description: "Convert integer number to other forms. It is useful for exploring how integer numbers are stored in computers.",
              color: .green
            )
          }
          NavigationLink(destination: SegmentorToolView()) {
            CardView(
              title: "Bits extractor",
              description: "Extract binary bits and convert segments to readable hexadecimal. It is useful for perceiving the value of each segment.",
              color: .pink
            )
          }
          NavigationLink(destination: FloatToolView()) {
            CardView(
              title: "Float inspector",
              description: "Inspect the raw representaion of floating-point numbers. It is useful for understanding the implementation of IEEE 754.",
              color: .purple
            )
          }
          CardView(
            title: "Coming soon...",
            description: "Thank you for using this app! I'm working hard to bring you more tools and features. Stay tuned and thank for your patience.",
            color: .gray
          )
          .opacity(0.8)
        }
      }
      .padding()
      .navigationTitle("Tools")
    }
  }
}

#Preview {
  ToolExploreView()
}
