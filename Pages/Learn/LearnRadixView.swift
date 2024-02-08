import LaTeXSwiftUI
import SwiftUI

struct LearnRadixView: View {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 28) {
        H2("What is radix")
        LaTeX("""
        Radix is a term used in mathematics and computer science to refer to the number of unique digits used to represent numbers.

        For example, the most common radix is 10, which is the base for the decimal system that uses digits from 0 to 9.

        In decimal, the number 128 can be represented by this formula:
        $8\\times 10^0 + 2\\times 10^1 + 1\\times 10^2$
        """)
        H2("Meet binary")
        LaTeX("""
        Binary numbers are a basic yet crucial concept in computing, representing values using only two digits: 0 and 1. The radix is 2 in this case.

        Here's a simple example: The binary number $(101)_2$ represents the decimal number 5. Similarly, we can write down the equation to see how it works:
        $1\\times 2^0 + 0\\times 2^1 + 1\\times 2^2$
        $= 1\\times 1 + 0\\times 2 + 1\\times 4 = 5$
        """)
        H2("Binary is too verbose")
        LaTeX("""
        If we write a slightly large number in binary, it will take forever. That's why we need octal and hexadecimal. Unlike decimal, they can be easily converted from and to binary.

        Octal is of radix 8, which uses digits from 0 to 7. Hexadecimal is of radix 16, which uses digits from 0 to 9 and A to F. In hexadecimal, A to F represent 10 to 15, respectively.

        For example, the decimal number 75 is $(0100\\_1011)_2$ in binary. Note that we group every 4 digits, because every 4 binary digits have an one-to-one relation with a hexadecimal digit.

        In this case, the lower 4 digits $(1011)_2$ is
        $1\\times 1 + 1\\times 2 + 0\\times 4 + 1\\times 8$
        $= 11 = (\\textrm{B})_{16}$
        And the upper 4 digits $(0100)_2$ is simply $(4)_{16}$ in hexadecimal. Thus, the decimal number 75 is represented as $(\\textrm{4B})_{16}$ in hexadecimal.
        """)
        H2("Further reading")
        Text("""
        [Number Base - Brilliant](https://brilliant.org/wiki/number-base/)
        """)
      }
      .font(.title2)
      .frame(
        maxWidth: .infinity,
        alignment: .topLeading
      )
      .navigationTitle("Number and radix")
      .padding()
    }
    .tint(.cyan)
  }
}

#Preview {
  LearnRadixView()
}
