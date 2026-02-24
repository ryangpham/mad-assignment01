import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = "0";
  double? firstOperand;
  String? operator;
  bool shouldResetDisplay = false;

  // button tap logic handler
  void handleButtonPress(String value) {
    setState(() {
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
        if (firstOperand != null && operator != null) {
          double secondOperand = double.parse(display);
          double result = calculate(firstOperand!, secondOperand, operator!);
          display = formatResult(result);
          firstOperand = null;
          operator = null;
          shouldResetDisplay = true;
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2633),
      body: SafeArea(
        child: Padding(
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
                    color: const Color(0xFF111827),
                  ),
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 60,
                      color: Color(0xFF69F0AE),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Buttons Grid
              Expanded(
                flex: 2,
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  children: [
                    buildButton("AC", isOperator: true),
                    buildButton("C", isOperator: true),
                    buildButton("%", isOperator: true),
                    buildButton("÷", isOperator: true),
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("×", isOperator: true),
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("-", isOperator: true),
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("+", isOperator: true),
                    buildButton("0"),
                    buildButton("."),
                    buildButton("=", isOperator: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
