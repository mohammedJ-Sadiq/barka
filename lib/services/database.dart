import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class DatabaseService {
  final String uid;
  final String name;
  List<String> readers = [''];

  final CollectionReference readerCollection =
      Firestore.instance.collection('readers');

  final CollectionReference sessionCollection =
      Firestore.instance.collection('sessions');

  List<ChapterAssignment> chapterAssignmentObj = [
    ChapterAssignment(uid: '', chapterNo: '')
  ];

  DatabaseService({this.uid, this.name});

  // to set the uid of the user (including the creator of the session) in the reader list
  List<String> setReaderUidReadersList(List<String> existedReaderList) {
    if (existedReaderList[0] == '') {
      existedReaderList[0] = uid;
      return existedReaderList;
    } else {
      existedReaderList.add(uid);
      return existedReaderList;
    }
  }

  // to populate chapter list
  List<ChapterAssignment> populateChapterList() {
    chapterAssignmentObj[0] = ChapterAssignment(uid: '', chapterNo: '1');
    for (var i = 2; i < 31; i++) {
      chapterAssignmentObj.add(ChapterAssignment(uid: '', chapterNo: '${i}'));
    }
    return chapterAssignmentObj;
  }

  // to create the user data once he register
  Future createUserData(String name, List<String> chaptersTaken) async {
    return await readerCollection.document(uid).setData({
      'uid': uid,
      'name': name,
      'chaptersTaken': chaptersTaken,
    });
  }

  // to create a new session
  Future createNewSession(
    String name,
    String description,
  ) async {
    DocumentSnapshot doc = await sessionCollection.document(name).get();
    if (!doc.exists) {
      String availableChapters = jsonEncode(populateChapterList());
      return await sessionCollection.document(name).setData({
        'creator': uid,
        'name': name,
        'description': description,
        'available_chapters': availableChapters,
        'readers': setReaderUidReadersList(readers),
      });
    } else {
      return 'error';
    }
  }

  // to join an eixsted session
  Future joinSession(String name, String description, String creatorId,
      String availableChapters, List<String> readers) async {
    DocumentSnapshot doc = await sessionCollection.document(name).get();
    if (doc.exists) {
      return await sessionCollection.document(name).setData({
        'creator': creatorId,
        'name': name,
        'description': description,
        'available_chapters': availableChapters,
        'readers': setReaderUidReadersList(readers),
      });
    } else {
      return 'error';
    }
  }

  List<Session> _chaptersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Session(
        description: doc.data['description'] ?? '',
        name: doc.data['name'] ?? '',
      );
    }).toList();
  }

  Stream<List<Session>> get chapters {
    print(uid);
    return sessionCollection
        .where('readers', arrayContains: uid)
        .snapshots()
        .map(_chaptersListFromSnapshot);
  }
}
