import 'package:flutter/material.dart';
import '../screens/visited_mosques_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            accountName: Text(
              "Kullanıcı Adı",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text("mümin@mail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.teal),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mosque, color: Colors.teal),
            title: const Text("Gittiğim Camiler"),
            onTap: () {
              Navigator.pop(context); // Menüyü kapat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitedMosquesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text("Ayarlar"),
            onTap: () {
              Navigator.pop(context);
              // Ayarlar sayfası eklenebilir
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Çıkış Yap"),
            onTap: () {
              // Çıkış işlemleri
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
