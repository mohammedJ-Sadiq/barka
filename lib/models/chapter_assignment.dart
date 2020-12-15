class ChapterAssignment {
  String uid;
  String name;
  bool chapterStatus;
  final String chapterNo;

  ChapterAssignment({this.uid, this.chapterNo, this.name, this.chapterStatus});

  ChapterAssignment.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        chapterNo = json['chapterNo'],
        name = json['name'],
        chapterStatus = json['chapterStatus'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'chapterNo': chapterNo,
        'name': name,
        'chapterStatus': chapterStatus,
      };
}
