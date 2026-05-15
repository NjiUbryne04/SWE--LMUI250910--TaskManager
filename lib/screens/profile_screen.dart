import 'package:flutter/material.dart';

// ProfileScreen is StatelessWidget because profile data never changes at runtime
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _primary = Color(0xFF2E6FD8); // steel blue
  static const Color _navy   = Color(0xFF1A2E4A); // deep navy

  @override
  Widget build(BuildContext context) {
    // Semester goals stored as a list of strings
    final List<String> goals = [
      'Master Flutter and build at least two complete mobile apps this semester.',
      'Achieve a distinction grade in all Level 400 Software Engineering courses.',
      'Contribute to an open-source project and document the experience on GitHub.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      backgroundColor: const Color(0xFFEEF1F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header Card ──────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                child: Row(
                  children: [
                    // CircleAvatar shows student initials
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFF1A2E4A), // navy avatar
                      child: Text(
                        'NUF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'NJI UBRYNE FRU',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2E4A), // navy name
                            ),
                          ),
                          const SizedBox(height: 6),
                          _infoRow(Icons.badge_outlined, 'LMUI250910'),
                          const SizedBox(height: 4),
                          _infoRow(Icons.school_outlined, 'Software Engineering'),
                          const SizedBox(height: 4),
                          _infoRow(Icons.layers_outlined, 'Level 400'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Bio Card ────────────────────────────────────────────────
            _sectionCard(
              icon: Icons.person_outline,
              title: 'About Me',
              child: const Text(
                'I am NJI UBRYNE FRU, a passionate Level 400 Software Engineering student '
                'with a strong interest in mobile application development and system design. '
                'I believe in writing clean, maintainable code and am committed to becoming '
                'a world-class software engineer who builds impactful technology solutions.',
                style: TextStyle(fontSize: 14, height: 1.7, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 12),

            // ── Goals Card ──────────────────────────────────────────────
            _sectionCard(
              icon: Icons.flag_rounded,
              title: 'Semester Goals',
              child: Column(
                children: goals
                    .asMap()
                    .entries
                    .map((e) => _goalTile(e.key + 1, e.value))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper: small row with an icon and label
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  // Helper: a card with a header section and child widget body
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  // Helper: numbered goal tile
  Widget _goalTile(int number, String goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: _primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              goal,
              style: const TextStyle(fontSize: 14, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}
