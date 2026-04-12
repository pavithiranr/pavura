import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class MyGTFSService {
  static const Map<String, List<String>> stationLines = {
    // Putrajaya Line
    'Kwasa Damansara': ['PY'],
    'Kampung Selamat': ['PY'],
    'Sungai Buloh': ['PY'],
    'Damansara Damai': ['PY'],
    'Sri Damansara Barat': ['PY'],
    'Sri Damansara Sentral': ['PY'],
    'Sri Damansara Timur': ['PY'],
    'Metro Prima': ['PY'],
    'Kepong Baru': ['PY'],
    'Jinjang': ['PY'],
    'Sri Delima': ['PY'],
    'Kampung Batu': ['PY'],
    'Kentomen': ['PY'],
    'Jalan Ipoh': ['PY'],
    'Sentul West': ['PY'],
    'Titiwangsa': ['PY', 'AG', 'SP'],
    'Hospital Kuala Lumpur': ['PY'],
    'Raja Uda': ['PY'],
    'Ampang Park': ['PY', 'KJ'],
    'Persiaran KLCC': ['PY'],
    'Conlay': ['PY'],
    'Tun Razak Exchange': ['PY', 'KGL'],
    'Cochrane': ['PY', 'KGL'],
    'Chan Sow Lin': ['PY', 'AG', 'SP'],
    'Bandar Malaysia Utara': ['PY'],
    'Bandar Malaysia Selatan': ['PY'],
    'Kuchai': ['PY'],
    'Taman Naga Emas': ['PY'],
    'Sungai Besi': ['PY', 'SP'],
    'Serdang Raya Utara': ['PY'],
    'Serdang Raya Selatan': ['PY'],
    'Serdang Jaya': ['PY'],
    'UPM': ['PY'],
    'Taman Equine': ['PY'],
    'Putra Permai': ['PY'],
    '16 Sierra': ['PY'],
    'Cyberjaya Utara': ['PY'],
    'Cyberjaya City Centre': ['PY'],
    'Putrajaya Sentral': ['PY'],

    // Kelana Jaya Line
    'Gombak': ['KJ'],
    'Taman Melati': ['KJ'],
    'Wangsa Maju': ['KJ'],
    'Sri Rampai': ['KJ'],
    'Setiawangsa': ['KJ'],
    'Jelatek': ['KJ'],
    'Dato\' Keramat': ['KJ'],
    'Damai': ['KJ'],
    'KLCC': ['KJ'],
    'Kampung Baru': ['KJ'],
    'Dang Wangi': ['KJ'],
    'Masjid Jamek': ['KJ', 'AG', 'SP'],
    'Pasar Seni': ['KJ', 'KGL'],
    'KL Sentral': ['KJ'],
    'Bangsar': ['KJ'],
    'Abdullah Hukum': ['KJ'],
    'Kerinchi': ['KJ'],
    'Universiti': ['KJ'],
    'Taman Jaya': ['KJ'],
    'Asia Jaya': ['KJ'],
    'Taman Paramount': ['KJ'],
    'Taman Bahagia': ['KJ'],
    'Kelana Jaya': ['KJ'],
    'Lembah Subang': ['KJ'],
    'Ara Damansara': ['KJ'],
    'Glenmarie': ['KJ'],
    'Subang Jaya': ['KJ'],
    'SS15': ['KJ'],
    'SS18': ['KJ'],
    'USJ 7': ['KJ'],
    'Taipan': ['KJ'],
    'Wawasan': ['KJ'],
    'USJ 21': ['KJ'],
    'Alam Megah': ['KJ'],
    'Subang Alam': ['KJ'],
    'Putra Heights': ['KJ', 'SP'],

    // Ampang Line
    'Sentul Timur': ['AG', 'SP'],
    'Sentul': ['AG', 'SP'],
    'PWTC': ['AG', 'SP'],
    'Sultan Ismail': ['AG', 'SP'],
    'Bandaraya': ['AG', 'SP'],
    'Plaza Rakyat': ['AG', 'SP'],
    'Hang Tuah': ['AG', 'SP'],
    'Pudu': ['AG', 'SP'],
    'Miharja': ['AG'],
    'Maluri': ['AG', 'KGL'],
    'Pandan Jaya': ['AG'],
    'Cempaka': ['AG'],
    'Cahaya': ['AG'],
    'Ampang': ['AG'],

    // Sri Petaling Line
    'Cheras': ['SP'],
    'Salak Selatan': ['SP'],
    'Bandar Tun Razak': ['SP'],
    'Bandar Tasik Selatan': ['SP'],
    'Bukit Jalil': ['SP'],
    'Sri Petaling': ['SP'],
    'Awan Besar': ['SP'],
    'Muhibbah': ['SP'],
    'Alam Sutera': ['SP'],
    'Kinrara BK5': ['SP'],
    'IOI Puchong Jaya': ['SP'],
    'Pusat Bandar Puchong': ['SP'],
    'Taman Perindustrian Puchong': ['SP'],
    'Bandar Puteri': ['SP'],
    'Puchong Perdana': ['SP'],
    'Puchong Prima': ['SP'],

    // Kajang Line
    'Kwasa Sentral': ['KGL'],
    'Kota Damansara': ['KGL'],
    'Surian': ['KGL'],
    'Mutiara Damansara': ['KGL'],
    'Bandar Utama': ['KGL'],
    'TTDI': ['KGL'],
    'Phileo Damansara': ['KGL'],
    'Pusat Bandar Damansara': ['KGL'],
    'Semantan': ['KGL'],
    'Muzium Negara': ['KGL'],
    'Merdeka': ['KGL'],
    'Bukit Bintang': ['KGL'],
    'Taman Pertama': ['KGL'],
    'Taman Midah': ['KGL'],
    'Taman Mutiara': ['KGL'],
    'Taman Connaught': ['KGL'],
    'Taman Suntex': ['KGL'],
    'Sri Raya': ['KGL'],
    'Bandar Tun Hussein Onn': ['KGL'],
    'Batu 11 Cheras': ['KGL'],
    'Bukit Dukung': ['KGL'],
    'Sungai Jernih': ['KGL'],
    'Stadium Kajang': ['KGL'],
    'Kajang': ['KGL'],
  };

  static const Map<String, Color> lineColors = {
    'PY': Colors.amber,
    'KJ': Colors.pink,
    'AG': Colors.orange,
    'SP': Colors.red,
    'KGL': Colors.green,
  };

  static int _calculateTravelTime(String startStation, String endStation) {
    final startLines = stationLines[startStation] ?? [];
    final endLines = stationLines[endStation] ?? [];
    
    // Check if stations share a line
    for (var line in startLines) {
      if (endLines.contains(line)) {
        switch (line) {
          case 'PY':
            return 10;
          case 'KJ':
            return 8;
          case 'AG':
            return 12;
          case 'SP':
            return 15;
          case 'KGL':
            return 10;
        }
      }
    }
    
    // For interchanges or different lines
    return 20;
  }

  static Future<List<Map<String, dynamic>>> getSchedule({
    required String startStation,
    required String endStation,
  }) async {
    try {
      final schedules = <Map<String, dynamic>>[];
      final now = DateTime.now();
      int currentHour = now.hour;
      int currentMinute = now.minute;
      final journeyTime = _calculateTravelTime(startStation, endStation);
      final lines = stationLines[startStation] ?? ['Unknown'];

      // Generate 5 upcoming departure times
      for (int i = 0; i < 5; i++) {
        var departureMinute = currentMinute + (i * 10); // 10-minute frequency
        var departureHour = currentHour;
        
        if (departureMinute >= 60) {
          departureHour = (currentHour + (departureMinute ~/ 60)) % 24;
          departureMinute = departureMinute % 60;
        }

        var arrivalMinute = departureMinute + journeyTime;
        var arrivalHour = departureHour;
        
        if (arrivalMinute >= 60) {
          arrivalHour = (departureHour + (arrivalMinute ~/ 60)) % 24;
          arrivalMinute = arrivalMinute % 60;
        }

        schedules.add({
          'startTime': '${departureHour.toString().padLeft(2, '0')}:${departureMinute.toString().padLeft(2, '0')}',
          'endTime': '${arrivalHour.toString().padLeft(2, '0')}:${arrivalMinute.toString().padLeft(2, '0')}',
          'duration': journeyTime,
          'lines': lines,
          'color': lineColors[lines.first] ?? Colors.grey,
        });
      }
      
      return schedules;
    } catch (e) {
      developer.log('Error getting schedule: $e');
      return [];
    }
  }
}