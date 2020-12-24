class ChaptersTaken {
  final String sessionName;
  int noOfChaptersTaken;

  ChaptersTaken({this.sessionName, this.noOfChaptersTaken});

  ChaptersTaken.fromJson(Map<String, dynamic> json)
      : sessionName = json['sessionName'],
        noOfChaptersTaken = json['no_of_chapters_taken'];

  Map<String, dynamic> toJson() => {
        'sessionName': sessionName,
        'no_of_chapters_taken': noOfChaptersTaken,
      };
}
