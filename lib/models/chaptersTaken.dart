class ChaptersTaken {
  final String sessionName;
  int noOfChaptersTaken;
  final int orderNum;

  ChaptersTaken({this.sessionName, this.noOfChaptersTaken, this.orderNum});

  ChaptersTaken.fromJson(Map<String, dynamic> json)
      : sessionName = json['sessionName'],
        noOfChaptersTaken = json['no_of_chapters_taken'],
        orderNum = json['orderNum'];

  Map<String, dynamic> toJson() => {
        'sessionName': sessionName,
        'no_of_chapters_taken': noOfChaptersTaken,
        'orderNum': orderNum,
      };
}
