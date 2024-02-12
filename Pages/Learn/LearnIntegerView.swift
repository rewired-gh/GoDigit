import LaTeXSwiftUI
import SwiftUI

struct LearnIntegerView: View {
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 28) {
        H2("It's binary after all")
        Text("""
        Most (if not all) computers store numbers in binary. The idea of binary is based on active-high and active-low states in digital circuits.

        Because any circuit can't be infinite, the width of number, namely how many digits can a number have, is usually a fixed value. Common widths of number (aka. word lengths) are 32, 64, and 8.
        """)
        H2("Overflow is a feature")
        LaTeX("""
        Consider we have number $(1111\\_1111)_2$ on an 8-bit computer. If we try to add 1 to this number, it will be $(1\\_0000\\_0000)_2$ theoretically.

        However, since we only have 8 binary digits for computation, the higher digits can't be store and will be simply ignored. In other words, the number overflows.
        """)
        H2("Unsigned and signed")
        Text("""
        Unsigned integer numbers use every digits in a computer to store a natural number. The previous example is an unsigned number. Signed numbers are number with sign, namely they can be positive or negative.

        But when it comes to store a signed number in the computer, things become a little bit trickier. If we simply use one bit to represent the sign, we encounter an issue of having duplicated zeros: a positive zero (+0) and a negative zero (-0).
        """)
        H2("Two's complement")
        Text("""
        One elegant but not so intuitive method to represent signed integer numbers in computer is the two's complement. It doesn't have the problem of having two zeros.

        Here we won't go through how to come up with this brilliant idea and why it is the de facto standard. We just simply learn about how to do conversions.

        We follow these steps to convert a number to its two's complement:

        1. Write down the binary absolute value of the original number.

        2. Flip every bit of the number, namely change 1s to 0s and 0s to 1s.

        3. Add 1 to the flipped number. Remember to ignore the overflowed digit.

        To convert from two's complement back to the original number, we just need to perform the same steps.

        Let's take the number -18 on an 8-bit computer as an example.

        1. Write down 18 in binary:
        """)
        Text("0001_0010")
          .font(.system(size: 24, design: .monospaced))
          .frame(maxWidth: .infinity)
          .padding(.top, -12)
        Text("""
        2. Flip every bits:
        """)
        Text("1110_1101")
          .font(.system(size: 24, design: .monospaced))
          .frame(maxWidth: .infinity)
          .padding(.top, -12)
        Text("""
        3. Add 1:
        """)
        HStack(spacing: 0) {
          Text("1110_11")
          Text("10")
            .foregroundStyle(.tint)
        }
        .font(.system(size: 24, design: .monospaced))
        .frame(maxWidth: .infinity)
        .padding(.top, -12)
        LaTeX("""
        The number -128 is a little bit special on an 8-bit computer. In fact, the $-2^{n-1}$ number is always special on an n-bit computer. Let's try to convert it.

        1. Write down 128 in binary:
        """)
        Text("1000_0000")
          .font(.system(size: 24, design: .monospaced))
          .frame(maxWidth: .infinity)
          .padding(.top, -12)
        Text("""
        2. Flip every bits:
        """)
        Text("0111_1111")
          .font(.system(size: 24, design: .monospaced))
          .frame(maxWidth: .infinity)
          .padding(.top, -12)
        Text("""
        3. Add 1:
        """)
        Text("1000_0000")
          .foregroundStyle(.tint)
          .font(.system(size: 24, design: .monospaced))
          .frame(maxWidth: .infinity)
          .padding(.top, -12)
        Text("""
        Interesting. The the two's complement of -128 is itself!

        Actually, two's complement is really a deep rabit hole. I strongly suggest to read the materials in the next section, if you want to learn more about it.
        """)
        H2("Further reading")
        Text("""
        [Two’s Complement - Baeldung](https://www.baeldung.com/cs/two-complement)

        [Two's Complement - Algebra Proof And Deep Dive - Simply Put](https://www.youtube.com/watch?v=JTFp0rRF30o)
        """)
      }
      .font(.title2)
      .frame(
        maxWidth: .infinity,
        alignment: .topLeading
      )
      .navigationTitle("Integer and computer")
      .padding()
    }
    .tint(.green)
  }
}

#Preview {
  LearnIntegerView()
}
