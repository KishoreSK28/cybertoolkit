// import 'package:flutter/material.dart';
import '../screens/tools/port_scanner_screen.dart';
import '../screens/tools/hash_generator_screen.dart';
import '../screens/tools/ip_lookup_screen.dart';
import '../screens/tools/dns_lookup_screen.dart';
import '../screens/tools/url_crawler_screen.dart';

class AppRoutes {
  static final routes = {
    '/portScanner': (context) => PortScannerScreen(),
    '/hashGen': (context) => HashGeneratorScreen(),
    '/ipLookup': (context) => IPLookupScreen(),
    '/dnsLookup': (context) => DNSResolverScreen(),
    '/urlcrawl': (context) => URLCrawlerScreen(),
  };
}
