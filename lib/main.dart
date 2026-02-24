import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorPage(
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const CalculatorPage({super.key, required this.onToggleTheme});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = "0";
  double? firstOperand;
  String? operator;
  bool shouldResetDisplay = false;
  String? errorMessage;

  // button tap logic handler
  void handleButtonPress(String value) {
    setState(() {
      // clear previous error when user presses button
      errorMessage = null;
      // if digit pressed
      if ("0123456789".contains(value)) {
        if (display == "0" || shouldResetDisplay) {
          display = value;
          shouldResetDisplay = false;
        } else {
          display += value;
        }
      }
      // clear current input
      else if (value == "C") {
        display = "0";
      }
      // clear all
      else if (value == "AC") {
        display = "0";
        firstOperand = null;
        operator = null;
        shouldResetDisplay = false;
      }
      // if operator pressed
      else if ("+-×÷".contains(value)) {
        firstOperand = double.parse(display);
        operator = value;
        shouldResetDisplay = true;
      }
      // if equals pressed
      else if (value == "=") {
        // check for incomplete operation
        if (firstOperand == null || operator == null) {
          errorMessage = "Error: Incomplete input";
          return;
        }

        double secondOperand = double.parse(display);
        // check for division by zero
        if (operator == "÷" && secondOperand == 0) {
          errorMessage = "Error: Division by zero";
          display = "0";
          firstOperand = null;
          operator = null;
          return;
        }

        double result = calculate(firstOperand!, secondOperand, operator!);
        display = formatResult(result);
        firstOperand = null;
        operator = null;
        shouldResetDisplay = true;
      }
    });
  }

  // perform arithmetic operation
  double calculate(double a, double b, String op) {
    switch (op) {
      case "+":
        return a + b;
      case "-":
        return a - b;
      case "×":
        return a * b;
      case "÷":
        return a / b;
      default:
        return 0;
    }
  }

  // remove trailing .0 from whole numbers
  String formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toString();
    }
  }

  Widget buildButton(String text, {bool isOperator = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isOperator
              ? const LinearGradient(
                  colors: [
                    Color(0xFF6A5AE0),
                    Color.fromARGB(255, 157, 112, 254),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF3E4A5E), Color(0xFF2C3445)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              handleButtonPress(text);
            },
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<Widget> children) {
    return Expanded(child: Row(children: children));
  }

  Widget buildExpandedButton(
    String text, {
    bool isOperator = false,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isOperator
                ? const LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF9D70FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF3E4A5E), Color(0xFF2C3445)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => handleButtonPress(text),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Display
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Text(
                        errorMessage ?? display,
                        style: errorMessage != null
                            ? const TextStyle(
                                fontSize: 40,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              )
                            : const TextStyle(
                                fontSize: 60,
                                color: Color(0xFF69F0AE),
                                fontWeight: FontWeight.w500,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Row 1
                        buildRow([
                          buildExpandedButton("AC", isOperator: true),
                          buildExpandedButton("C", isOperator: true),
                          buildExpandedButton("%", isOperator: true),
                          buildExpandedButton("÷", isOperator: true),
                        ]),

                        // Row 2
                        buildRow([
                          buildExpandedButton("7"),
                          buildExpandedButton("8"),
                          buildExpandedButton("9"),
                          buildExpandedButton("×", isOperator: true),
                        ]),

                        // Row 3
                        buildRow([
                          buildExpandedButton("4"),
                          buildExpandedButton("5"),
                          buildExpandedButton("6"),
                          buildExpandedButton("-", isOperator: true),
                        ]),

                        // Row 4
                        buildRow([
                          buildExpandedButton("1"),
                          buildExpandedButton("2"),
                          buildExpandedButton("3"),
                          buildExpandedButton("+", isOperator: true),
                        ]),

                        // Row 5
                        buildRow([
                          buildExpandedButton("0", flex: 2),
                          buildExpandedButton("."),
                          buildExpandedButton("=", isOperator: true),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // theme toggle
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.brightness_6),
                  onPressed: widget.onToggleTheme,
                  tooltip: 'Toggle Light/Dark Mode',
                  splashRadius: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
