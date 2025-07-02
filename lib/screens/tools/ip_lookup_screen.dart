import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IPLookupScreen extends StatefulWidget {
  const IPLookupScreen({super.key});

  @override
  State<IPLookupScreen> createState() => _IPLookupScreenState();
}

class _IPLookupScreenState extends State<IPLookupScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? ipData;
  bool isLoading = false;
  final String apiKey = 'dcae265b38224b099d56d0bda947090e'; // Replace with your actual API key

  Future<String?> getPublicIP() async {
    try {
      final res = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['ip'];
      }
    } catch (e) {
      showError("Failed to fetch public IP: $e");
    }
    return null;
  }

  bool isPrivateIP(String ip) {
    return ip.startsWith("192.") ||
           ip.startsWith("10.") ||
           ip.startsWith("172.") ||
           ip.startsWith("127.");
  }

  Future<void> fetchIPInfo(String ip) async {
    if (isPrivateIP(ip)) {
      showError("Private IPs like $ip can't be geolocated.");
      return;
    }

    setState(() {
      isLoading = true;
      ipData = null;
    });

    final url = "https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&ip=$ip";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          ipData = data;
        });
      } else {
        showError("API Error: ${response.statusCode}");
      }
    } catch (e) {
      showError("Error fetching data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Widget buildResult() {
    if (ipData == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoTile("IP", ipData!["ip"]),
        infoTile("Continent", ipData!["continent_name"]),
        infoTile("Country", ipData!["country_name"]),
        infoTile("Region", ipData!["state_prov"]),
        infoTile("City", ipData!["city"]),
        infoTile("ISP", ipData!["isp"]),
        infoTile("Timezone", ipData!["time_zone"]["name"]),
        infoTile("Latitude", ipData!["latitude"]),
        infoTile("Longitude", ipData!["longitude"]),
        infoTile("Currency", ipData!["currency"]["name"]),
        infoTile("Calling Code", ipData!["calling_code"]),
        infoTile("Organization", ipData!["organization"]),
      ],
    );
  }

  Widget infoTile(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: SelectableText(value.toString())),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getPublicIP().then((ip) {
      if (ip != null) {
        _controller.text = ip;
        fetchIPInfo(ip);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IP Lookup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Enter IP or domain (e.g. 8.8.8.8)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : () => fetchIPInfo(_controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                  : const Text("Lookup"),
            ),
            const SizedBox(height: 20),
            if (ipData != null)
              Expanded(child: SingleChildScrollView(child: buildResult())),
          ],
        ),
      ),
    );
  }
}
