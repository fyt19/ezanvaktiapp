import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text("Kıble Bulucu"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error.toString()}"));
          }
          if (snapshot.data!) {
            return const QiblaCompass();
          } else {
            return const Center(child: Text("Cihazınızda pusula sensörü yok."));
          }
        },
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Pusula kalibre ediliyor..."),
              ],
            ),
          );
        }

        final qiblahDirection = snapshot.data!;

        // Açıyı hesapla
        var direction = qiblahDirection.qiblah * (pi / 180) * -1;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Derece Bilgisi
              Text(
                "${qiblahDirection.qiblah.toStringAsFixed(1)}°",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Kabe Yönü",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // PUSULA GÖRSELİ
              SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Dış Çember (Sabit - Resim Yüklemiyoruz, Kodla Çiziyoruz)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                    ),

                    // Sabit Kuzey/Güney İşaretleri (Süsleme)
                    const Positioned(
                      top: 10,
                      child: Text(
                        "N",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      child: Text(
                        "S",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 10,
                      child: Text(
                        "E",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 10,
                      child: Text(
                        "W",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // 2. Dönen İğne ve Kabe
                    Transform.rotate(
                      angle: direction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Kabe İkonu (İnternetten çekmiyoruz, garanti olsun diye Icon kullanıyoruz)
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.mosque,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),

                          const SizedBox(height: 80), // Merkezden uzaklık
                          // Okun kuyruğu (Görsellik için)
                          Container(
                            width: 4,
                            height: 30,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),

                    // Merkez Noktası
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              // Uyarı Mesajı
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Doğru sonuç için telefonunuzu 8 çizerek kalibre edin ve metal eşyalardan uzak tutun.",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
