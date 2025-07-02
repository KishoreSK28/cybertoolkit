import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class URLCrawlerScreen extends StatefulWidget {
  const URLCrawlerScreen({super.key});

  @override
  State<URLCrawlerScreen> createState() => _URLCrawlerScreenState();
}

class _URLCrawlerScreenState extends State<URLCrawlerScreen> {
  final TextEditingController _urlController = TextEditingController();
  List<String> links = [];
  bool isLoading = false;

  Future<void> fetchUrls() async {
    final website = _urlController.text.trim();

    if (!website.startsWith('http')) {
      _showError("Enter a valid URL starting with http or https.");
      return;
    }

    setState(() {
      isLoading = true;
      links.clear();
    });

    try {
      final response = await http.get(Uri.parse(website));

      if (response.statusCode == 200) {
        // 👇 Use the alias 'dom.Document'
        dom.Document document = parser.parse(response.body);
        final anchorTags = document.getElementsByTagName('a');

        for (var anchor in anchorTags) {
          final href = anchor.attributes['href'];
          if (href != null && href.isNotEmpty) {
            links.add(href);
          }
        }
      } else {
        _showError("Failed to load website.");
      }
    } catch (e) {
      _showError("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("URL Crawler")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: "Enter website URL (e.g. https://example.com)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: isLoading ? null : fetchUrls,
              icon: const Icon(Icons.link),
              label: Text(isLoading ? "Scanning..." : "Scan URLs"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            if (links.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: links.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          links[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
