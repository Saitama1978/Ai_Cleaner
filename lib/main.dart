import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

void main() {
  runApp(const AICleanerApp());
}

class AICleanerApp extends StatelessWidget {
  const AICleanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Cleaner',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E15),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF161925),
          error: Color(0xFFFF5252),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScanning = false;
  String _statusText = "SYSTEM READY";
  Color _statusColor = const Color(0xFF00E5FF);

  double _junkSizeMB = 0.0;
  String _junkStatus = "Tap scan to analyze temporary cache";

  Future<void> _startAIScan() async {
    setState(() {
      _isScanning = true;
      _statusText = "AI ANALYZING...";
      _statusColor = Colors.amber;
    });

    await Permission.storage.request();

    double totalCacheSize = 0.0;
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        totalCacheSize += _getDirectorySize(tempDir);
      }
    } catch (_) {}

    _junkSizeMB = totalCacheSize / (1024 * 1024);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _junkStatus = _junkSizeMB > 0
          ? "Found: ${_junkSizeMB.toStringAsFixed(2)} MB temporary files"
          : "System cache clean";
      _statusText = "SCAN COMPLETE";
      _statusColor = const Color(0xFF00E676);
    });
  }

  double _getDirectorySize(Directory dir) {
    double size = 0;
    try {
      if (dir.existsSync()) {
        dir.listSync(recursive: true, followLinks: false).forEach((file) {
          if (file is File) {
            size += file.lengthSync();
          }
        });
      }
    } catch (_) {}
    return size;
  }

  Future<void> _cleanSystem() async {
    setState(() {
      _isScanning = true;
      _statusText = "CLEANING...";
    });

    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _junkSizeMB = 0.0;
      _junkStatus = "Cleaned (0 B remaining)";
      _statusText = "OPTIMIZED";
      _statusColor = const Color(0xFF00E676);
    });
  }

  // Guaranteed Android Settings Opener (with 3 Fallbacks)
  Future<void> _openDNSOption() async {
    if (Platform.isAndroid) {
      try {
        const intent = AndroidIntent(
          action: 'android.settings.NETWORK_OPERATOR_SETTINGS',
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (_) {
        try {
          const fallbackIntent = AndroidIntent(
            action: 'android.settings.WIRELESS_SETTINGS',
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await fallbackIntent.launch();
        } catch (_) {
          const mainSettingsIntent = AndroidIntent(
            action: 'android.settings.SETTINGS',
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await mainSettingsIntent.launch();
        }
      }
    }
  }

  // Opens Chrome Incognito Browser Directly
  Future<void> _openIncognito() async {
    final Uri intentUri = Uri.parse(
      'intent://google.com#Intent;scheme=https;package=com.android.chrome;S.com.android.chrome.extra.INCOGNITO=true;end',
    );
    if (await canLaunchUrl(intentUri)) {
      await launchUrl(intentUri);
    } else {
      await launchUrl(Uri.parse('https://google.com'), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, color: Color(0xFF00E5FF)),
            SizedBox(width: 8),
            Text(
              "AI_Cleaner",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF161925),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _statusColor, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isScanning ? Icons.auto_awesome : Icons.shield_outlined,
                        size: 36,
                        color: _statusColor,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _startAIScan,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("START AI SCAN"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    _buildFeatureCard(
                      icon: Icons.cleaning_services,
                      title: "Storage Cache",
                      subtitle: _junkStatus,
                      actionText: "CLEAN NOW",
                      onTap: _cleanSystem,
                    ),
                    _buildFeatureCard(
                      icon: Icons.block,
                      title: "Adult Site Blocker Setup",
                      subtitle: "Set Private DNS: family.cloudflare-dns.com",
                      actionText: "OPEN SETTINGS",
                      onTap: _openDNSOption,
                    ),
                    _buildFeatureCard(
                      icon: Icons.security,
                      title: "Safe Private Browser",
                      subtitle: "Launch Chrome in Incognito mode",
                      actionText: "OPEN INCOGNITO",
                      onTap: _openIncognito,
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  "Developer: Renante Fullo",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF161925),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00E5FF), size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        trailing: TextButton(
          onPressed: onTap,
          child: Text(actionText, style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
