import 'package:flutter/material.dart';

const Map<String, IconData> _iconMap = {
  'work': Icons.work,
  'drive': Icons.directions_car,
  'restaurant': Icons.restaurant,
  'shower': Icons.shower,
  'bed': Icons.bed,
  'fitness': Icons.fitness_center,
  'book': Icons.menu_book,
  'weekend': Icons.weekend,
  'games': Icons.sports_esports,
  'school': Icons.school,
  'cleaning': Icons.cleaning_services,
  'shopping': Icons.shopping_cart,
  'walk': Icons.directions_walk,
  'people': Icons.people,
  'palette': Icons.palette,
  'computer': Icons.computer,
  'code': Icons.code,
  'smartphone': Icons.smartphone,
  'email': Icons.email,
  'attach_money': Icons.attach_money,
  'account_balance': Icons.account_balance,
  'credit_card': Icons.credit_card,
  'business': Icons.business,
  'architecture': Icons.architecture,
  'science': Icons.science,
  'memory': Icons.memory,

  'flight': Icons.flight,
  'train': Icons.train,
  'subway': Icons.subway,
  'directions_bike': Icons.directions_bike,
  'directions_bus': Icons.directions_bus,
  'directions_boat': Icons.directions_boat,
  'local_gas_station': Icons.local_gas_station,
  'public': Icons.public,
  'map': Icons.map,

  'coffee': Icons.coffee,
  'local_drink': Icons.local_drink,
  'local_pizza': Icons.local_pizza,
  'cake': Icons.cake,
  'icecream': Icons.icecream,
  'kitchen': Icons.kitchen,

  'home': Icons.home,
  'chair': Icons.chair,
  'child_care': Icons.child_care,
  'pets': Icons.pets,
  'spa': Icons.spa,
  'wash': Icons.wash,
  'yard': Icons.yard,

  'local_hospital': Icons.local_hospital,
  'local_pharmacy': Icons.local_pharmacy,
  'medical_services': Icons.medical_services,
  'favorite': Icons.favorite,

  'sports_soccer': Icons.sports_soccer,
  'sports_basketball': Icons.sports_basketball,
  'sports_tennis': Icons.sports_tennis,
  'pool': Icons.pool,
  'downhill_skiing': Icons.downhill_skiing,
  'directions_run': Icons.directions_run,
  'nature_people': Icons.nature_people,
  'park': Icons.park,
  'celebration': Icons.celebration,
  'theater_comedy': Icons.theater_comedy,

  'camera_alt': Icons.camera_alt,
  'movie': Icons.movie,
  'music_note': Icons.music_note,
  'mic': Icons.mic,
  'library_music': Icons.library_music,
  'smart_toy': Icons.smart_toy,
  'auto_awesome': Icons.auto_awesome,
  'emoji_events': Icons.emoji_events,
};

IconData getIconData(String code) {
  return _iconMap[code] ?? Icons.local_activity;
}

//экспорт
final List<String> availableIconCodes = _iconMap.keys.toList();