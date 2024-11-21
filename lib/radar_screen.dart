import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'radar_controller.dart';

class RadarLocationSearchPage extends StatelessWidget {
  const RadarLocationSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RadarController controller = Get.put(RadarController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Radar Location Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller.locationController,
                decoration: const InputDecoration(
                  labelText: "Search Location",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await controller.searchLocations(pattern);
              },
              itemBuilder: (context, Map<String, String> suggestion) {
                return ListTile(
                  title: Text(suggestion["name"] ?? ""),
                  subtitle: Text(suggestion["formattedAddress"] ?? ""),
                );
              },
              onSuggestionSelected: (Map<String, String> suggestion) {
                controller.updateStatus(suggestion);
                controller.locationController.text = suggestion["name"] ?? "";
              },
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No locations found."),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
                  () => Text(
                controller.statusMessage.value,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
