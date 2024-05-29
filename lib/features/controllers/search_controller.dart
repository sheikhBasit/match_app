// controllers/search_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final List<String> matches = [
    'Match 1: Team A vs Team B',
    'Match 2: Team C vs Team D',
    'Match 3: Team E vs Team F',
    'Match 4: Team G vs Team H',
    'Match 5: Team I vs Team J',
    // Add more matches here
  ].obs;

  final RxList<String> filteredMatches = <String>[].obs;

  void filterMatches(String value) {
    filteredMatches.value = matches
        .where((match) => match.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
