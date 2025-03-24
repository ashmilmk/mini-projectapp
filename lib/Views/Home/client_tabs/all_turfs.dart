import 'package:flutter/material.dart';

class TurfListPage extends StatefulWidget {
  const TurfListPage({super.key});

  @override
  _TurfListPageState createState() => _TurfListPageState();
}

class _TurfListPageState extends State<TurfListPage> {
  List<Turf> turfs = [
    Turf(
      name: 'Perintalmanna Turf',
      imageUrl: 'assets/images/1.jpg',
      price: 200,
      location: 'Perintalmanna',
    ),
    Turf(
      name: 'Malappuram Turf',
      imageUrl: 'assets/images/2.jpg',
      price: 180,
      location: 'Malappuram',
    ),
    Turf(
      name: 'Melattur Turf',
      imageUrl: 'assets/images/3.jpg',
      price: 220,
      location: 'Melattur',
    ),
    // Add more turfs here
  ];

  List<Turf> filteredTurfs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredTurfs = turfs;
  }

  void _filterTurfs(String query) {
    setState(() {
      filteredTurfs = turfs
          .where((turf) =>
              turf.name.toLowerCase().contains(query.toLowerCase()) ||
              turf.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterTurfs,
              decoration: const InputDecoration(
                hintText: 'Search turfs',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTurfs.length,
              itemBuilder: (context, index) {
                final turf = filteredTurfs[index];
                return TurfCard(
                  name: turf.name,
                  imageUrl: turf.imageUrl,
                  price: turf.price,
                  location: turf.location,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TurfCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int price;
  final String location;

  const TurfCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(name),
        subtitle: Text('Location: $location'),
        trailing: Text('Rs$price'),
      ),
    );
  }
}

class Turf {
  final String name;
  final String imageUrl;
  final int price;
  final String location;

  Turf({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.location,
  });
}
