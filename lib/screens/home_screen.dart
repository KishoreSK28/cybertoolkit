import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String localIP = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _getLocalIP();
  }

  Future<void> _getLocalIP() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();
    setState(() {
      localIP = ip ?? 'Unavailable';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cyber Toolkit'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.greenAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.security,
                      color: Colors.greenAccent,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cyber Toolkit',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'By SK Kishore',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.usb_rounded),
              title: const Text('Port Scanner'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/portScanner');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Hash Generator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/hashGen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('IP Lookup'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ipLookup');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dns),
              title: const Text('DNS Resolver'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dnsLookup');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Url Crwaler'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/urlcrawl');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Cyber Toolkit',
                  applicationVersion: '1.0.0',
                  children: [
                    const Text(
                      'Made with ❤️ by SK Kishore\nA toolkit for ethical hacking & cybersecurity.',
                    ),
                  ],
                );
              },
            ),
            
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.greenAccent),
            const SizedBox(height: 10),
            const Text(
              'Cyber Toolkit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A mini ethical hacking toolbox made with Flutter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            // Card(
            //   margin: const EdgeInsets.symmetric(vertical: 20),
            //   color: Colors.grey[900],
            //   child: const ListTile(
            //     leading: CircleAvatar(
            //       backgroundColor: Colors.green,
            //       child: Text('K', style: TextStyle(color: Colors.black)),
            //     ),
            //     title: Text('SK Kishore'),
            //     subtitle: Text('Cybersecurity Enthusiast & Developer'),
            //   ),
            // ),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/portScanner'),
                  icon: const Icon(Icons.usb),
                  label: const Text('Port Scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                  ),                  
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/hashGen'),
                  icon: const Icon(Icons.lock),
                  label: const Text('Hash Generator'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/ipLookup'),
                  icon: const Icon(Icons.language),
                  label: const Text('IP Lookup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/dnsLookup'),
                  icon: const Icon(Icons.dns),
                  label: const Text('DNS Resolver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                  ),
                ),
                ElevatedButton.icon(onPressed: ()=> Navigator.pushNamed(context, '/urlcrawl'),
                icon:const Icon(Icons.search),
                label: const Text('url crawler'),                
                style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700]
                )
                )
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.grey[850],
              child: const ListTile(
                leading: Icon(Icons.analytics, color: Colors.greenAccent),
                title: Text('Tools Available'),
                subtitle: Text('4 cybersecurity tools integrated'),
              ),
            ),
            Card(
              color: Colors.grey[850],
              child: ListTile(
                leading: const Icon(Icons.wifi, color: Colors.greenAccent),
                title: const Text('Network Status'),
                subtitle: Text('Online - Local IP: $localIP'),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                launchUrl(
                  Uri.parse("mailto:kishoresenthamarai2004@gmail.com"),
                ); // optional feedback
              },
              icon: const Icon(Icons.feedback),
              label: const Text("Send Feedback"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                launchUrl(Uri.parse("https://github.com/KishoreSK28"));
              },
              icon: const Icon(Icons.code),
              label: const Text("View on GitHub"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.greenAccent,
                side: const BorderSide(color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const Text(
              "v1.0.0 • Made by SK Kishore",
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
