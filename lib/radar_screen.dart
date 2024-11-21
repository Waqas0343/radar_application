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
        title:  Text("Radar Location Search", style: Get.textTheme.titleSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
            fontSize: 16,
        ),),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadFormField(
              direction: AxisDirection.down,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                enabled: true,
                keyboardType: TextInputType.text,
                controller: controller.locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  labelStyle: const TextStyle(color: Colors.red),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade500),
                  ),
                  suffixIcon: controller.isLoading.value
                      ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.blue)
                      : const Icon(Icons.search, color: Colors.red),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await controller.searchLocations(pattern);
              },
              itemBuilder: (context, Map<String, String> suggestion) {
                return ListTile(
                  leading: Text(
                    suggestion["countryFlag"] ?? "🇫🇮",
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    suggestion["name"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),
                  subtitle: Text(
                    suggestion["formattedAddress"] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
              onSuggestionSelected: (Map<String, String> suggestion) {
                controller.updateStatus(suggestion);
                controller.locationController.text = suggestion["name"] ?? "";
              },
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No locations found.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
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
