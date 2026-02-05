import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitedMosquesScreen extends StatefulWidget {
  const VisitedMosquesScreen({super.key});

  @override
  State<VisitedMosquesScreen> createState() => _VisitedMosquesScreenState();
}

class _VisitedMosquesScreenState extends State<VisitedMosquesScreen> {
  // Şimdilik verileri burada listede tutuyoruz. İleride Hive'a kaydederiz.
  final List<Map<String, String>> _visitedPlaces = [
    {
      'name': 'Ayasofya Camii',
      'date': DateTime.now().subtract(const Duration(days: 10)).toString(),
    },
    {
      'name': 'Sultanahmet Camii',
      'date': DateTime.now().subtract(const Duration(days: 50)).toString(),
    },
  ];

  void _addMosque() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cami/Mescit Ekle"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Cami İsmi Giriniz"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _visitedPlaces.insert(0, {
                    'name': controller.text,
                    'date': DateTime.now().toString(),
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Ekle"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gittiğim Camiler"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _visitedPlaces.isEmpty
          ? const Center(child: Text("Henüz bir cami eklemediniz."))
          : ListView.builder(
              itemCount: _visitedPlaces.length,
              itemBuilder: (context, index) {
                final place = _visitedPlaces[index];
                final date = DateTime.parse(place['date']!);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.mosque, color: Colors.white),
                    ),
                    title: Text(
                      place['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Ziyaret: ${DateFormat('d MMMM yyyy', 'tr_TR').format(date)}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _visitedPlaces.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMosque,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
