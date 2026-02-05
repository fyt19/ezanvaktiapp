import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import '../services/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  PrayerTimes? _prayerTimes;
  String _currentCity = "Konum Alınıyor...";
  bool _isLoading = true;
  String _errorMessage = '';

  // Geri sayım için timer
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  String _nextPrayerName = "";

  @override
  void initState() {
    super.initState();
    _initData();
    // Her saniye ekranı yenilemek için timer başlat
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prayerTimes != null) {
        _calculateRemainingTime();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initData() async {
    try {
      final position = await _prayerService.determinePosition();
      final city = await _prayerService.getCityName(
        position.latitude,
        position.longitude,
      );
      final times = _prayerService.getPrayerTimes(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _prayerTimes = times;
        _currentCity = city;
        _isLoading = false;
      });
      _calculateRemainingTime();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _calculateRemainingTime() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    final next = _prayerTimes!.nextPrayer();
    DateTime? nextTime;

    // Adhan kütüphanesinden gelen nextPrayer enum'ını zamana ve isme çevir
    switch (next) {
      case Prayer.fajr:
        _nextPrayerName = "İmsak";
        nextTime = _prayerTimes!.fajr;
        break;
      case Prayer.sunrise:
        _nextPrayerName = "Güneş";
        nextTime = _prayerTimes!.sunrise;
        break;
      case Prayer.dhuhr:
        _nextPrayerName = "Öğle";
        nextTime = _prayerTimes!.dhuhr;
        break;
      case Prayer.asr:
        _nextPrayerName = "İkindi";
        nextTime = _prayerTimes!.asr;
        break;
      case Prayer.maghrib:
        _nextPrayerName = "Akşam";
        nextTime = _prayerTimes!.maghrib;
        break;
      case Prayer.isha:
        _nextPrayerName = "Yatsı";
        nextTime = _prayerTimes!.isha;
        break;
      case Prayer.none:
      default:
        // Eğer günün son namazı geçtiyse, sonraki günün imsak vaktini hedefle
        _nextPrayerName = "İmsak (Yarın)";
        // Burası biraz trick gerektirir, basitlik adına şimdilik yatsı sonrası diyelim
        // veya ertesi günün imsak vaktini hesaplatmak gerekir.
        // Şimdilik null check yapalım.
        nextTime = _prayerTimes!.fajr.add(const Duration(days: 1));
        break;
    }

    if (nextTime != null) {
      setState(() {
        _timeRemaining = nextTime!.difference(now);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(_errorMessage),
              ),
            )
          : Column(
              children: [
                // ÜST HEADER KISMI
                _buildHeader(),

                // VAKİTLER LİSTESİ
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildTimeRow("İmsak", _prayerTimes!.fajr, Prayer.fajr),
                        _buildTimeRow(
                          "Güneş",
                          _prayerTimes!.sunrise,
                          Prayer.sunrise,
                        ),
                        _buildTimeRow(
                          "Öğle",
                          _prayerTimes!.dhuhr,
                          Prayer.dhuhr,
                        ),
                        _buildTimeRow("İkindi", _prayerTimes!.asr, Prayer.asr),
                        _buildTimeRow(
                          "Akşam",
                          _prayerTimes!.maghrib,
                          Prayer.maghrib,
                        ),
                        _buildTimeRow("Yatsı", _prayerTimes!.isha, Prayer.isha),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF009688), Color(0xFF004D40)], // Teal to Dark Teal
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Şehir ve Tarih
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _currentCity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('d MMMM yyyy', 'tr_TR').format(
                      DateTime.now(),
                    ), // tr_TR için intl date format ayarlamak gerekir, şimdilik varsayılan
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),

              // Geri Sayım Ortası
              Center(
                child: Column(
                  children: [
                    Text(
                      "$_nextPrayerName Vaktine Kalan",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatDuration(_timeRemaining),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow(String title, DateTime time, Prayer prayer) {
    // Şu anki vakti bulmak için
    final currentPrayer = _prayerTimes!.currentPrayer();
    final isCurrent = currentPrayer == prayer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.teal.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: isCurrent ? Border.all(color: Colors.teal, width: 2) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                color: isCurrent ? Colors.teal : Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  color: isCurrent ? Colors.teal[800] : Colors.grey[800],
                  fontSize: 18,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            DateFormat.Hm().format(time),
            style: TextStyle(
              color: isCurrent ? Colors.teal[800] : Colors.grey[800],
              fontSize: 18,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
