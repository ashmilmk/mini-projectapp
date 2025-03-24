import 'package:flutter/material.dart';

class TournamentsTab extends StatefulWidget {
  const TournamentsTab({super.key});

  @override
  State<TournamentsTab> createState() => _TournamentsTabState();
}

class _TournamentsTabState extends State<TournamentsTab> {
  List<Map<String, dynamic>> tournaments = [
    {
      'name': 'Panthattam',
      'date': '15 June 2024',
      'location': 'Vengoor',
      'prize': 'Rs 10,000',
    },
    {
      'name': '7S Tournament',
      'date': '25 July 2024',
      'location': 'Perinthalmanna',
      'prize': 'Rs 5,000 ',
    },
    {
      'name': 'Regional Championship',
      'date': '16 May 2024',
      'location': 'Manjeri',
      'prize': 'Rs 7000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tournaments'),
      ),
      body: ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournaments[index];
          return Card(
            child: ListTile(
              leading: const SizedBox(), // Remove the leading Image.asset
              title: Text(tournament['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${tournament['date']}'),
                  Text('Location: ${tournament['location']}'),
                  Text('Prize: ${tournament['prize']}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle tournament card tap
              },
            ),
          );
        },
      ),
    );
  }
}