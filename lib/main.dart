import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionModes {
  static const CBC = encrypt.AESMode.cbc;
  static const CFB64 = encrypt.AESMode.cfb64;
  static const CTR = encrypt.AESMode.ctr;
  static const ECB = encrypt.AESMode.ecb;
  static const OFB64GCTR = encrypt.AESMode.ofb64Gctr;
  static const OFB64 = encrypt.AESMode.ofb64;
  static const SIC = encrypt.AESMode.sic;
  static const PADDING = 'PKCS7';
}

class DesEncryptionScreen extends StatefulWidget {
  const DesEncryptionScreen({super.key});

  @override
  _DesEncryptionScreenState createState() => _DesEncryptionScreenState();
}

class _DesEncryptionScreenState extends State<DesEncryptionScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _ivController = TextEditingController();
  String _selectedMode = 'CBC';
  String _result = '';
  bool _isEncryption = true;

  final List<String> _modes = ['CBC', 'CFB64', 'CTR', 'ECB', 'OFB64GCTR'];

  void _performDesEncryption() {
    final key =
        encrypt.Key.fromUtf8(_keyController.text.padRight(8).substring(0, 8));
    final iv =
        encrypt.IV.fromUtf8(_ivController.text.padRight(8).substring(0, 8));

    final desMode = {
      'CBC': EncryptionModes.CBC,
      'CFB64': EncryptionModes.CFB64,
      'CTR': EncryptionModes.CTR,
      'ECB': EncryptionModes.ECB,
      'OFB64GCTR': EncryptionModes.OFB64GCTR,
    }[_selectedMode]!;

    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        key,
        mode: desMode,
        padding: EncryptionModes.PADDING,
      ),
    );

    final text = _controller.text;

    setState(() {
      if (_isEncryption) {
        final encrypted = encrypter.encrypt(text, iv: iv);
        _result = encrypted.base64;
      } else {
        final decrypted = encrypter.decrypt64(text, iv: iv);
        _result = decrypted;
      }
    });
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
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Text to Encrypt/Decrypt'),
            ),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: 'Key (8 characters)'),
              maxLength: 8,
            ),
            TextField(
              controller: _ivController,
              decoration: const InputDecoration(
                  labelText: 'IV (optional for ECB, 8 characters)'),
              maxLength: 8,
            ),
            DropdownButton<String>(
              value: _selectedMode,
              onChanged: (newMode) {
                setState(() {
                  _selectedMode = newMode!;
                });
              },
              items: _modes.map<DropdownMenuItem<String>>((String mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEncryption = true;
                    });
                    _performDesEncryption();
                  },
                  child: const Text('Encrypt'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEncryption = false;
                    });
                    _performDesEncryption();
                  },
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
              style: const  TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
