String formatWithCommas(int value) {
  final String input = value.toString();
  final StringBuffer output = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    final int reverseIndex = input.length - i;
    output.write(input[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      output.write(',');
    }
  }

  return output.toString();
}
