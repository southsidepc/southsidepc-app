import 'package:intl/intl.dart';

class DevotionData {
  String id; // Firebase key
  String title; // Title of devotion
  String date; // Date of devotion
  String verseText; // Verse for devotion, e.g., 'John 3:16-17'
  String verseURL; // URL for above verse in online Bible
  String listenURL; // URL for podcast
  String prayerPoints; // list of prayer points
  String imageName; // filename of background image?
  String imageURL; // URL for background image

  DevotionData.fromDB(Map<String, dynamic> dbEntry, {String id = ""})
      : id = id,
        title = dbEntry['title'] ?? '',
        date = dbEntry['date'] ?? '',
        verseText = dbEntry['verseText'] ?? '',
        verseURL = dbEntry['verseURL'] ?? '',
        listenURL = dbEntry['listenURL'] ?? '',
        prayerPoints = dbEntry['prayerPoints'] ?? '',
        imageName = dbEntry['imageName'] ?? '',
        imageURL = dbEntry['imageURL'] ?? '';

  DateTime toLocalDateTime() {
    return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(date, true).toLocal();
  }

  String toMonthYear() {
    return DateFormat("MMMM yyyy").format(toLocalDateTime());
  }
}

class MonthOfDevotions {
  final List<DevotionData> devotions = [];
  final String monthYear;

  MonthOfDevotions(this.monthYear);

  void addDevotion(DevotionData devotion) {
    devotions.add(devotion);
  }
}
