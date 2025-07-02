import 'dart:io';
import 'package:flutter/material.dart';

class PortScannerScreen extends StatefulWidget {
  const PortScannerScreen({super.key});

  @override
  State<PortScannerScreen> createState() => _PortScannerScreenState();
}

class _PortScannerScreenState extends State<PortScannerScreen> {
  final TextEditingController ipController =
      TextEditingController(text: "scanme.nmap.org");
  final TextEditingController startPortController =
      TextEditingController(text: "20");
  final TextEditingController endPortController =
      TextEditingController(text: "100");

  List<int> openPorts = [];
  bool isScanning = false;

  // ✅ Common ports with service names
  final Map<int, String> portServices = {
    20: 'FTP (Data)',
    21: 'FTP (Control)',
    22: 'SSH',
    23: 'Telnet',
    25: 'SMTP',
    53: 'DNS',
    67: 'DHCP (Server)',
    68: 'DHCP (Client)',
    69: 'TFTP',
    80: 'HTTP',
    110: 'POP3',
    123: 'NTP',
    135: 'Microsoft RPC',
    137: 'NetBIOS Name',
    138: 'NetBIOS Datagram',
    139: 'NetBIOS Session',
    143: 'IMAP',
    161: 'SNMP',
    179: 'BGP',
    194: 'IRC',
    443: 'HTTPS',
    445: 'SMB',
    465: 'SMTPS',
    514: 'Syslog',
    520: 'RIP',
    587: 'SMTP (Submission)',
    631: 'IPP (Printer)',
    993: 'IMAPS',
    995: 'POP3S',
    3306: 'MySQL',
    3389: 'RDP',
    5432: 'PostgreSQL',
    5900: 'VNC',
    8080: 'HTTP-Alt',
  };

  @override
  void dispose() {
    ipController.dispose();
    startPortController.dispose();
    endPortController.dispose();
    super.dispose();
  }

  Future<void> scanPorts(String ip, int startPort, int endPort) async {
    setState(() {
      isScanning = true;
      openPorts.clear();
    });

    List<Future<void>> tasks = [];

    for (int port = startPort; port <= endPort; port++) {
      tasks.add(_scanPort(ip, port));
    }

    await Future.wait(tasks);

    if (mounted) {
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _scanPort(String ip, int port) async {
    try {
      final socket =
          await Socket.connect(ip, port, timeout: const Duration(milliseconds: 300));
      socket.destroy();
      if (mounted) {
        setState(() {
          openPorts.add(port);
        });
      }
    } catch (_) {
      // Do nothing if port is closed or unreachable
    }
  }

  void _startScan() {
    final ip = ipController.text.trim();
    final startPort = int.tryParse(startPortController.text.trim()) ?? 0;
    final endPort = int.tryParse(endPortController.text.trim()) ?? 0;

    if (ip.isEmpty || startPort <= 0 || endPort <= 0 || startPort > endPort) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid IP and port range."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    scanPorts(ip, startPort, endPort);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Port Scanner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                hintText: "Target IP or domain (e.g. scanme.nmap.org)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startPortController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Start port (e.g. 20)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: endPortController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "End port (e.g. 100)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isScanning ? null : _startScan,
              icon: isScanning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(isScanning ? 'Scanning...' : 'Start Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[700],
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 20),
            if (!isScanning && openPorts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: openPorts.length,
                  itemBuilder: (context, index) {
                    final port = openPorts[index];
                    final service = portServices[port] ?? 'Unknown';
                    return Card(
                      color: Colors.black12,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle_outline,
                            color: Colors.greenAccent),
                        title: Text('Port $port is open'),
                        subtitle: Text('Service: $service'),
                      ),
                    );
                  },
                ),
              ),
            if (!isScanning && openPorts.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "No open ports found or scan not started.",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
