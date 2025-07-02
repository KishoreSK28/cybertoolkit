import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DNSResolverScreen extends StatefulWidget {
  const DNSResolverScreen({super.key});

  @override
  State<DNSResolverScreen> createState() => _DNSResolverScreenState();
}

class _DNSResolverScreenState extends State<DNSResolverScreen> {
  final TextEditingController _domainController = TextEditingController();
  List<String> results = [];
  bool isLoading = false;

  final List<Map<String, dynamic>> recordTypes = [
    {'name': 'A', 'code': 1},
    {'name': 'AAAA', 'code': 28},
    {'name': 'CNAME', 'code': 5},
    {'name': 'MX', 'code': 15},
    {'name': 'NS', 'code': 2},
    {'name': 'TXT', 'code': 16},
  ];

  Future<void> resolveDNS() async {
    final domain = _domainController.text.trim();

    if (domain.isEmpty) {
      showError("Please enter a domain.");
      return;
    }

    setState(() {
      isLoading = true;
      results.clear();
    });

    for (var type in recordTypes) {
      final response = await http.get(
        Uri.parse(
          "https://dns.google/resolve?name=$domain&type=${type['code']}",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Answer'] != null) {
          for (var answer in data['Answer']) {
            results.add("${type['name']} → ${answer['data']}");
          }
        }
      } else {
        showError("Failed to fetch ${type['name']} record.");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfect DNS Resolver")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                hintText: "Enter domain (e.g. google.com)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: isLoading ? null : resolveDNS,
              icon:
                  isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.search),
              label: Text(isLoading ? 'Resolving...' : 'Resolve DNS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            if (results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          results[index],
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
