import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  // Örnek Sure Listesi (Demo için elle ekledik)
  final List<Map<String, String>> surahs = const [
    {
      'no': '1',
      'name': 'Fatiha Suresi',
      'desc': 'Mekke • 7 Ayet',
      'arabic': 'الفاتحة',
    },
    {
      'no': '2',
      'name': 'Bakara Suresi',
      'desc': 'Medine • 286 Ayet',
      'arabic': 'البقرة',
    },
    {
      'no': '36',
      'name': 'Yasin Suresi',
      'desc': 'Mekke • 83 Ayet',
      'arabic': 'يس',
    },
    {
      'no': '67',
      'name': 'Mülk Suresi',
      'desc': 'Mekke • 30 Ayet',
      'arabic': 'الملك',
    },
    {
      'no': '78',
      'name': 'Nebe Suresi',
      'desc': 'Mekke • 40 Ayet',
      'arabic': 'النبأ',
    },
    {
      'no': '112',
      'name': 'İhlas Suresi',
      'desc': 'Mekke • 4 Ayet',
      'arabic': 'الإخلاص',
    },
    {
      'no': '113',
      'name': 'Felak Suresi',
      'desc': 'Mekke • 5 Ayet',
      'arabic': 'الفلق',
    },
    {
      'no': '114',
      'name': 'Nas Suresi',
      'desc': 'Mekke • 6 Ayet',
      'arabic': 'الناس',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/2865/2865882.png',
                    ), // Yıldız motifi
                    opacity: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  surah['no']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              title: Text(
                surah['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(surah['desc']!),
              trailing: Text(
                surah['arabic']!,
                style: const TextStyle(
                  fontFamily: 'Amiri', // Arapça fontu (varsa) yoksa default
                  fontSize: 20,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Detay sayfasına git (Basit bir okuma ekranı)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SurahDetailScreen(title: surah['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Basit Okuma Ekranı (Placeholder)
class SurahDetailScreen extends StatelessWidget {
  final String title;
  const SurahDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book, size: 80, color: Colors.teal),
              SizedBox(height: 20),
              Text(
                "Sure metni buraya gelecek.\n(API veya PDF entegrasyonu yapılabilir)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
