// views/search_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:match_app/features/controllers/search_controller.dart';


class SearchPage extends StatelessWidget {
  final SearchBarController searchController = Get.put(SearchBarController());

   SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: searchController.searchController,
              onChanged: (value) {
                searchController.filterMatches(value);
              },
            ),
            const SizedBox(height: 20),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: searchController.filteredMatches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchController.filteredMatches[index]),
                      onTap: () {
                        // Navigate to search result page
                        Get.toNamed('/search_result');
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
