import 'package:flutter/material.dart';

void main() {
  runApp(const MobileCleanerApp());
}

class MobileCleanerApp extends StatelessWidget {
  const MobileCleanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Cleaner & Privacy Shield',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676),
          secondary: Color(0xFF29B6F6),
          surface: Color(0xFF1E1E1E),
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
  bool _isCleaned = false;
  String _statusText = "READY";
  Color _statusColor = const Color(0xFF00E676);

  String _junkStatus = "Temporary files, app logs & cache";
  String _privacyStatus = "Anonymous browsing & adult site traces";
  String _malwareStatus = "Dangerous ads & adware scripts";

  void _startScanning() async {
    setState(() {
      _isScanning = true;
      _isCleaned = false;
      _statusText = "SCANNING...";
      _statusColor = Colors.amber;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _junkStatus = "Found: 420 MB temporary junk files";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _privacyStatus = "Found: Adult site history & tracking cookies";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _malwareStatus = "Found: Adware cache & pop-up scripts";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isScanning = false;
      _statusText = "THREATS FOUND";
      _statusColor = const Color(0xFFFF5252);
    });
  }

  void _cleanSystem() async {
    setState(() {
      _isScanning = true;
      _statusText = "CLEANING...";
      _statusColor = const Color(0xFF29B6F6);
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _isCleaned = true;
      _junkStatus = "Cleaned (0 B remaining)";
      _privacyStatus = "Cleared history & cookies";
      _malwareStatus = "Removed adware & malware cache";
      _statusText = "PROTECTED";
      _statusColor = const Color(0xFF00E676);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🛡️ Mobile Cleaner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.stretch,
            children: [
              // Circular Progress Display
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _statusColor, width: 6),
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withAlpha(50),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _statusText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Scan Button
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _startScanning,
                icon: const Icon(Icons.radar),
                label: const Text("START FULL SCAN"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF29B6F6),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // Status Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildStatusCard(
                      icon: Icons.delete_outline,
                      title: "Junk & Cache",
                      subtitle: _junkStatus,
                      isWarning: _junkStatus.contains("Found"),
                    ),
                    _buildStatusCard(
                      icon: Icons.security,
                      title: "Privacy & Adult Site Traces",
                      subtitle: _privacyStatus,
                      isWarning: _privacyStatus.contains("Found"),
                    ),
                    _buildStatusCard(
                      icon: Icons.bug_report_outlined,
                      title: "Malware & Adware",
                      subtitle: _malwareStatus,
                      isWarning: _malwareStatus.contains("Found"),
                    ),
                  ],
                ),
              ),

              // Clean Button
              ElevatedButton.icon(
                onPressed: (_statusText == "THREATS FOUND" && !_isScanning)
                    ? _cleanSystem
                    : null,
                icon: const Icon(Icons.cleaning_services),
                label: const Text("CLEAN NOW"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              // Developer Footer
              const Center(
                child: Text(
                  "Developed by: Renante Fullo",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isWarning,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: isWarning ? const Color(0xFFFF5252) : const Color(0xFF00E676),
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isWarning ? const Color(0xFFFF5252) : Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
