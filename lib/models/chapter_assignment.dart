class ChapterAssignment {
  final String uid;
  final String chapterNo;

  ChapterAssignment({this.uid, this.chapterNo});

  ChapterAssignment.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        chapterNo = json['chapterNo'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'chapterNo': chapterNo,
      };
}
