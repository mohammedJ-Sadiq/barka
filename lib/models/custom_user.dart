import 'package:barka/models/chaptersTaken.dart';

class CustomUser {
  final String uid;
  final String name;
  final List<ChaptersTaken> chaptersTaken;

  CustomUser({this.uid, this.name, this.chaptersTaken});
}
