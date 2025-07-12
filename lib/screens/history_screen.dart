import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class Traduction {
  final String text;
  final String hour;

  Traduction({required this.text, required this.hour});
}

class HistoryDay {
  final String date;
  final List<Traduction> translations;

  HistoryDay({required this.date, required this.translations});
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _expandedKey;
  List<HistoryDay> history = [];

  void _onTileTapped(String key) {
    setState(() {
      _expandedKey = (_expandedKey == key) ? null : key;
    });
  }

  Future<void> loadUserHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final data = doc.data();

      if (data == null) return;

      final historyData = data['history'] as Map<String, dynamic>?;

      if (historyData == null) return;

      List<HistoryDay> h = [];

      historyData.forEach((date, value) {
        List<Traduction> t = [];
        final translations = value as Map<String, dynamic>;

        final sortedEntries =
            translations.entries.toList()
              ..sort((a, b) => _compareTime(a.value, b.value));

        for (var entry in sortedEntries) {
          t.add(Traduction(text: entry.key, hour: entry.value as String));
        }

        h.add(HistoryDay(date: date, translations: t));
      });

      h.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        history = h;
      });
    }
  }

  int _compareTime(String a, String b) {
    int toSeconds(String time) {
      final parts = time.toLowerCase().split(' ');
      final hourMinSec = parts[0].split(':');

      int hour = int.parse(hourMinSec[0]);
      int min = int.parse(hourMinSec[1]);
      int sec = hourMinSec.length > 2 ? int.parse(hourMinSec[2]) : 0;

      final isPm = parts[1] == 'pm';

      if (hour == 12) {
        hour = isPm ? 12 : 0;
      } else if (isPm) {
        hour += 12;
      }

      return hour * 3600 + min * 60 + sec;
    }

    return toSeconds(b).compareTo(toSeconds(a));
  }

  @override
  void initState() {
    loadUserHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EC6E9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            spacing: 12,
            children: [
              const SizedBox(width: double.infinity),
              Text(
                "HISTORIAL DE TRADUCCIONES",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              ...history.map(
                (item) => DynamicCollapsibleTile(
                  historyDay: item,
                  expanded: _expandedKey == item.date,
                  onTap: () => _onTileTapped(item.date),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicCollapsibleTile extends StatelessWidget {
  final HistoryDay historyDay;
  final bool expanded;
  final VoidCallback onTap;

  const DynamicCollapsibleTile({
    super.key,
    required this.historyDay,
    required this.expanded,
    required this.onTap,
  });

  String formatDate(String dateISO) {
    final parts = dateISO.split('-'); // ["2025", "07", "12"]
    final year = parts[0];
    final month = int.parse(parts[1]);
    final date = parts[2];

    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final monthDisplay = months[month];

    return '$date de $monthDisplay de $year';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkResponse(
                onTap: onTap,
                containedInkWell: false,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDate(historyDay.date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(expanded ? Icons.expand_less : Icons.expand_more),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: AnimatedOpacity(
                  opacity: expanded ? 1 : 0,
                  duration: Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: expanded ? historyDay.translations.length * 28 : 0,
                    child: Column(
                      children: [
                        ...historyDay.translations.map((item) {
                          final time = item.hour.split(" ");
                          final hour = time[0].split(":");
                          final ampm = time[1];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Traducido: ${item.text.split("-")[0]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "${hour[0]}:${hour[1]} $ampm",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
