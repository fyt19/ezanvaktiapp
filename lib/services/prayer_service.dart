import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart'; // Yeni ekledik

class PrayerService {
  // 1. Konum İzni ve Koordinat Alma
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisleri kapalı.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Konum izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Konum izinleri kalıcı olarak reddedildi.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // 2. Namaz Vakitlerini Hesaplama
  PrayerTimes getPrayerTimes(double latitude, double longitude) {
    final myCoordinates = Coordinates(latitude, longitude);

    // Türkiye Diyanet İşleri parametreleri
    final params = CalculationMethod.turkey.getParameters();
    params.madhab = Madhab.hanafi;

    // ÖNEMLİ: Cihazın yerel saat dilimine göre tarihi alıyoruz
    final date = DateComponents.from(DateTime.now());

    return PrayerTimes(myCoordinates, date, params);
  }

  // 3. Koordinattan Şehir İsmi Bulma (Yeni)
  Future<String> getCityName(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // İlçe (SubAdminArea) veya İl (AdministrativeArea) döndür
        return "${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}";
      }
      return "Konum Bulunamadı";
    } catch (e) {
      return "Bilinmeyen Konum";
    }
  }
}
