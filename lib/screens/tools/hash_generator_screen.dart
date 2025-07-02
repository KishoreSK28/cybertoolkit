import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HashGeneratorScreen extends StatefulWidget {
  const HashGeneratorScreen({super.key});

  @override
  State<HashGeneratorScreen> createState() => _HashGeneratorScreenState();
}

class _HashGeneratorScreenState extends State<HashGeneratorScreen> {
  final TextEditingController _inputController = TextEditingController();

  String md5Hash = '';
  String sha1Hash = '';
  String sha256Hash = '';

  void _generateHashes() {
    final input = _inputController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter some text to generate hash."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final bytes = utf8.encode(input);
    setState(() {
      md5Hash = md5.convert(bytes).toString();
      sha1Hash = sha1.convert(bytes).toString();
      sha256Hash = sha256.convert(bytes).toString();
    });
  }

  void _copyToClipboard(String hash) {
    Clipboard.setData(ClipboardData(text: hash));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied to clipboard"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clear() {
    _inputController.clear();
    setState(() {
      md5Hash = '';
      sha1Hash = '';
      sha256Hash = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hash Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                hintText: "Enter text here",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateHashes,
                    child: const Text("Generate"),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _clear,
                  child: const Icon(Icons.clear),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (md5Hash.isNotEmpty) _buildHashTile("MD5", md5Hash),
            if (sha1Hash.isNotEmpty) _buildHashTile("SHA-1", sha1Hash),
            if (sha256Hash.isNotEmpty) _buildHashTile("SHA-256", sha256Hash),
          ],
        ),
      ),
    );
  }

  Widget _buildHashTile(String label, String hash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: SelectableText(
                hash,
                style: const TextStyle(fontSize: 14, color: Colors.greenAccent),
              ),
            ),
            IconButton(
              onPressed: () => _copyToClipboard(hash),
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
