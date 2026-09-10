import 'package:flutter/material.dart';

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

  String _junkStatus = "Temporary files, app logs & cache";
  String _privacyStatus = "Anonymous browsing & adult site traces";
  String _malwareStatus = "Dangerous ads & adware scripts";

  void _startAIScan() async {
    setState(() {
      _isScanning = true;
      _statusText = "AI ANALYZING...";
      _statusColor = Colors.amber;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _junkStatus = "Found: 520 MB junk & residual files";
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
      _statusText = "THREATS DETECTED";
      _statusColor = const Color(0xFFFF5252);
    });
  }

  void _cleanSystem() async {
    setState(() {
      _isScanning = true;
      _statusText = "AI CLEANING...";
      _statusColor = const Color(0xFF00E5FF);
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _junkStatus = "Cleaned (0 B remaining)";
      _privacyStatus = "Cleared history & tracking cookies";
      _malwareStatus = "Removed adware & malware cache";
      _statusText = "OPTIMIZED";
      _statusColor = const Color(0xFF00E676);
    });
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
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              // AI Circle Progress Display
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _statusColor, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withOpacity(0.25),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isScanning ? Icons.auto_awesome : Icons.shield_outlined,
                        size: 40,
                        color: _statusColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _statusColor,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Scan Button
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _startAIScan,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("START AI SCAN"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // Status Cards List
              Expanded(
                child: ListView(
                  children: [
                    _buildStatusCard(
                      icon: Icons.cleaning_services,
                      title: "Junk & Storage Cache",
                      subtitle: _junkStatus,
                      isWarning: _junkStatus.contains("Found"),
                    ),
                    _buildStatusCard(
                      icon: Icons.no_adult_content,
                      title: "Privacy & Adult Site Traces",
                      subtitle: _privacyStatus,
                      isWarning: _privacyStatus.contains("Found"),
                    ),
                    _buildStatusCard(
                      icon: Icons.security_update_warning,
                      title: "Malware & Adware Shield",
                      subtitle: _malwareStatus,
                      isWarning: _malwareStatus.contains("Found"),
                    ),
                  ],
                ),
              ),

              // Clean Button
              ElevatedButton.icon(
                onPressed: (_statusText == "THREATS DETECTED" && !_isScanning)
                    ? _cleanSystem
                    : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("OPTIMIZE NOW"),
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
                  "Developer: Renante Fullo",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
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
      color: const Color(0xFF161925),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isWarning
              ? const Color(0xFFFF5252).withOpacity(0.5)
              : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isWarning ? const Color(0xFFFF5252) : const Color(0xFF00E676),
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isWarning ? const Color(0xFFFF5252) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
