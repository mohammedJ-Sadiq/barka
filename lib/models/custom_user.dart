import 'package:barka/models/chaptersTaken.dart';

class CustomUser {
  final String uid;
  final String name;
  bool isEmailVerified;
  final List<ChaptersTaken> chaptersTaken;

  CustomUser({this.uid, this.name, this.chaptersTaken, this.isEmailVerified});
}
