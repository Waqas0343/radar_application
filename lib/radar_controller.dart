import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_radar/flutter_radar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RadarController extends GetxController {
  final TextEditingController locationController = TextEditingController();
  final statusMessage = "Type a location to search.".obs;
  final locations = <Map<String, String>>[].obs;
  final radarApiKey = "prj_live_sk_01e3698647ad49d849e3562f4a6280de1161c055";
  final isLoading = false.obs;

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
      isLoading.value = true;
      final url = "https://api.radar.io/v1/search/autocomplete?query=$query&near=40.7128,-74.0060";
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": radarApiKey,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Api Date : $data");
        final addresses = data["addresses"] as List<dynamic>;
        isLoading.value = false;
        return addresses
            .map((address) => {
          "name": address["name"]?.toString() ?? "",
          "formattedAddress": address["formattedAddress"]?.toString() ?? ""
        })
            .toList();
      } else {
        isLoading.value = false;
        return [];
      }
    } catch (e) {
      print("Error fetching locations: $e");
      isLoading.value = false;
      return [];
    }
  }

  void updateStatus(Map<String, String> location) {
    statusMessage.value =
    "Selected Location: ${location['name']}, Address: ${location['formattedAddress']}";
  }
}
