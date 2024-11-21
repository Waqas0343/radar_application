import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_radar/flutter_radar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RadarController extends GetxController {
  final TextEditingController locationController = TextEditingController();
  final statusMessage = "Type a location to search.".obs;
  final locations = <Map<String, String>>[].obs;
  final radarApiKey = "YOUR_RADAR_API_KEY";

  @override
  void onInit() {
    super.onInit();
    initializeRadar();
  }

  Future<void> initializeRadar() async {
    try {
      await Radar.initialize(radarApiKey);
      statusMessage.value = "Radar initialized successfully!";
    } catch (e) {
      statusMessage.value = "Error initializing Radar: $e";
    }
  }

  Future<List<Map<String, String>>> searchLocations(String query) async {
    try {
      final url =
          "https://api.radar.io/v1/search/autocomplete?query=$query&near=40.7128,-74.0060";
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": radarApiKey,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addresses = data["addresses"] as List<dynamic>;
        return addresses
            .map((address) => {
          "name": address["name"]?.toString() ?? "",
          "formattedAddress": address["formattedAddress"]?.toString() ?? ""
        })
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching locations: $e");
      return [];
    }
  }

  void updateStatus(Map<String, String> location) {
    statusMessage.value =
    "Selected Location: ${location['name']}, Address: ${location['formattedAddress']}";
  }
}
