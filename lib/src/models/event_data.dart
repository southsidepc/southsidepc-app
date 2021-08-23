class EventData {
  String imageName;
  String link;
  String date;
  String title;
  String image;
  String content;

  EventData(this.imageName, this.link, this.date, this.title, this.image,
      this.content);

  EventData.fromDB(Map<String, dynamic> dbEntry)
      : imageName = dbEntry["imageName"],
        link = dbEntry["link"],
        date = dbEntry["date"],
        title = dbEntry["title"],
        image = dbEntry["image"],
        content = dbEntry["content"];
}
