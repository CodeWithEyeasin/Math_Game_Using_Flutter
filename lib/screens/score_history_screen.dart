import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreHistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> scoreHistory;

  const ScoreHistoryScreen({super.key, required this.scoreHistory});

  @override
  State<ScoreHistoryScreen> createState() => _ScoreHistoryScreenState();
}

class _ScoreHistoryScreenState extends State<ScoreHistoryScreen> {
  List<Map<String, dynamic>> scoreHistory = [];

  @override
  void initState() {
    super.initState();
    _loadScoreHistory();
    _saveScoreHistory();
  }

  Future<void> _loadScoreHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoreHistoryString = prefs.getString('scoreHistory');
    if (scoreHistoryString != null) {
      setState(() {
        scoreHistory = List<Map<String, dynamic>>.from(
          json.decode(scoreHistoryString) as List,
        );
      });
    }
  }

  Future<void> _saveScoreHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('scoreHistory', json.encode(scoreHistory));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF323D5B),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
                const SizedBox(width: 53),
                const Text(
                  'Score History',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.scoreHistory.length,
              itemBuilder: (context, index) {
                final scoreEntry = widget.scoreHistory[index];
                return ListTile(
                  title: Text(
                    '${scoreEntry['playerName']} - ${scoreEntry['score']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    scoreEntry['date'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
