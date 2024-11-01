import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';

void main() {
  runApp(
    const MaterialApp(
      home: DesEncryptionScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class DesEncryptionScreen extends StatefulWidget {
  const DesEncryptionScreen({super.key});

  @override
  _DesEncryptionScreenState createState() => _DesEncryptionScreenState();
}

class _DesEncryptionScreenState extends State<DesEncryptionScreen> {
  final TextEditingController _textController = TextEditingController(
      text: "This is the text for encryption written by Yaroslava Shyt");
  final TextEditingController _keyController = TextEditingController(
    text: "u1BvOHzUOcklgNpn1MaWvdn9DT4LyzSX",
  );
  final TextEditingController _ivController = TextEditingController(
    text: "12345678",
  );
  String _result = '';

  Future<void> _encrypt() async {
    try {
      final text = _textController.text;
      final key = _keyController.text;
      final iv = _ivController.text;

      final encryptedText = await FlutterDes.encryptToHex(text, key, iv: iv);
      setState(() {
        _result = encryptedText.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Encryption failed: $e';
        print(e.toString());
      });
    }
  }

  Future<void> _decrypt() async {
    try {
      final encryptedText = _textController.text;
      final key = _keyController.text;
      final iv = _ivController.text;

      final decryptedText =
          await FlutterDes.decryptFromHex(encryptedText, key, iv: iv);
      setState(() {
        _result = decryptedText ?? 'not decrypted';
      });
    } catch (e) {
      setState(() {
        _result = 'Decryption failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DES Encryption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration:
                  const InputDecoration(labelText: 'Text to Encrypt/Decrypt'),
            ),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: 'Key'),
            ),
            TextField(
              controller: _ivController,
              decoration: const InputDecoration(labelText: 'IV'),
              maxLength: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _encrypt,
                  child: const Text('Encrypt'),
                ),
                ElevatedButton(
                  onPressed: _decrypt,
                  child: const Text('Decrypt'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Result:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText(
              _result,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
