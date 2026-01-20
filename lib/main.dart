import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '0';

  // Handle button presses
  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        displayText = '0';
      } else if (value == '=') {
        _calculate();
      } else if (value == '⌫') {
        if (displayText.length > 1) {
          displayText = displayText.substring(0, displayText.length - 1);
        } else {
          displayText = '0';
        }
      } else {
        if (displayText == '0' || displayText == 'Error') {
          displayText = value;
        } else {
          displayText += value;
        }
      }
    });
  }

  // Calculation logic
  void _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(displayText);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      displayText = eval.toString();
    } catch (e) {
      displayText = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Calculator')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                displayText,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            _buildButtonRow(['C', '⌫']),
            _buildButtonRow(['7', '8', '9', '/']),
            _buildButtonRow(['4', '5', '6', '*']),
            _buildButtonRow(['1', '2', '3', '-']),
            _buildButtonRow(['0', '.', "=", '+']),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((btn) {
          // Set different colors for "C" and "⌫"
          Color? buttonColor;
          buttonColor = Color.fromARGB(255, 204, 204, 204);
          if (btn == 'C') {
            buttonColor = Colors.red; // Red color for clear
          } else if (btn == '⌫') {
            buttonColor = Colors.orange; // Orange color for backspace
          } else if (btn == "=") {
            //buttonColor = Colors.blue;
          } else if (btn == "+" || btn == "-" || btn == "*" || btn == "/") {
            buttonColor = Colors.green; // Orange color for backspace
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: btn.isEmpty ? null : () => _onButtonPressed(btn),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  minimumSize: Size(70, 70),
                  backgroundColor: buttonColor, // Apply custom color
                ),
                child: Text(
                  btn,
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
