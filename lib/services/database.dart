import 'package:barka/models/chapter_assignment.dart';
import 'package:barka/models/chaptersTaken.dart';
import 'package:barka/models/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class DatabaseService {
  final String uid;
  final String name;
  List<String> readers = [''];
  List<ChaptersTaken> chaptersTaken = [
    ChaptersTaken(sessionName: '', noOfChaptersTaken: 0)
  ];

  final CollectionReference readerCollection =
      FirebaseFirestore.instance.collection('readers');

  final CollectionReference sessionCollection =
      FirebaseFirestore.instance.collection('sessions');

  List<ChapterAssignment> chapterAssignmentObj = [
    ChapterAssignment(uid: '', chapterNo: '', name: '')
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
    chapterAssignmentObj[0] = ChapterAssignment(
        uid: '', chapterNo: '1', name: '', chapterStatus: false);
    for (var i = 2; i < 31; i++) {
      chapterAssignmentObj.add(ChapterAssignment(
          uid: '', chapterNo: '$i', name: '', chapterStatus: false));
    }
    return chapterAssignmentObj;
  }

  // to create the user data once he register
  Future createUserData(String name, String phoneNumber) async {
    return await readerCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'chaptersTaken': jsonEncode(chaptersTaken),
    });
  }

  // to create a new session
  Future createNewSession(
    String name,
    String description,
  ) async {
    DocumentSnapshot doc = await sessionCollection.doc(name).get();
    if (!doc.exists) {
      String availableChapters = jsonEncode(populateChapterList());
      await sessionCollection.doc('--stat--').get().then((value) => {
            if (value.exists)
              {
                sessionCollection
                    .doc('--stat--')
                    .update({'counter': FieldValue.increment(1)})
              }
            else
              {
                sessionCollection.doc('--stat--').set({'counter': 1})
              }
          });
      int orderNum = await sessionCollection
          .doc('--stat--')
          .get()
          .then((value) => value.data()['counter']);
      return await sessionCollection.doc(name).set({
        'creator': uid,
        'name': name,
        'description': description,
        'available_chapters': availableChapters,
        'readers': setReaderUidReadersList(readers),
        'no_of_chapters_taken': 0,
        'no_of_chapters_finished': 0,
        'order': orderNum,
      });
    } else {
      return 'error';
    }
  }

  // to join an eixsted session
  Future joinSession(
      String name,
      String description,
      String creatorId,
      String availableChapters,
      List<String> readers,
      int noOfChaptersTaken,
      int noOfChaptersFinished,
      int orderNum) async {
    DocumentSnapshot doc = await sessionCollection.doc(name).get();
    if (doc.exists) {
      return await sessionCollection.doc(name).set({
        'creator': creatorId,
        'name': name,
        'description': description,
        'available_chapters': availableChapters,
        'readers': setReaderUidReadersList(readers),
        'no_of_chapters_taken': noOfChaptersTaken,
        'no_of_chapters_finished': noOfChaptersFinished,
        'order': orderNum,
      });
    } else {
      return 'error';
    }
  }

  Future<List<ChaptersTaken>> getChaptersTakenFromUid() async {
    String chaptersTaken = await readerCollection
        .doc(uid)
        .get()
        .then((value) => value.data()['chaptersTaken']);
    List decodedChaptersTaken = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList = decodedChaptersTaken
        .map((json) => ChaptersTaken.fromJson(json))
        .toList();

    return chaptersTakenList;
  }

  // to update the number of chpaters taken in a session
  Future updateNoOfChaptersTaken() async {
    String chapters = await sessionCollection
        .doc(name)
        .get()
        .then((value) => value.data()['available_chapters']);
    List decodedChapters = jsonDecode(chapters);
    List<ChapterAssignment> chapterAssignmentList = decodedChapters
        .map((json) => ChapterAssignment.fromJson(json))
        .toList();
    int noOfChaptersTaken =
        _getNoOfChaptersTakenFromChapterAssignment(chapterAssignmentList);
    return await sessionCollection
        .doc(name)
        .update({'no_of_chapters_taken': noOfChaptersTaken});
  }

  int _getNoOfChaptersTakenFromChapterAssignment(
      List<ChapterAssignment> chapters) {
    int _noOfChaptersTaken = 0;
    for (var i = 0; i < 30; i++) {
      if (chapters[i].uid != '') {
        _noOfChaptersTaken++;
      }
    }
    return _noOfChaptersTaken;
  }

  // to update the number of chapter taken by a user in all sessions
  Future updateNoOfChaptersTakenForAUser(bool increase) async {
    String chaptersTaken = await readerCollection
        .doc(uid)
        .get()
        .then((value) => value.data()['chaptersTaken']);
    List decodedChaptersTaken = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList = decodedChaptersTaken
        .map((json) => ChaptersTaken.fromJson(json))
        .toList();
    List<ChaptersTaken> modifiedChaptersTaken =
        await _updateChaptersTakenByUser(chaptersTakenList, increase);

    return await readerCollection
        .doc(uid)
        .update({'chaptersTaken': jsonEncode(modifiedChaptersTaken)});
  }

  _updateChaptersTakenByUser(List<ChaptersTaken> chaptersTaken, bool increase) {
    if (increase) {
      for (var i = 0; i < chaptersTaken.length; i++) {
        if (chaptersTaken[i].sessionName == name) {
          chaptersTaken[i].noOfChaptersTaken++;
          return chaptersTaken;
        }
      }
      return null;
    } else {
      for (var i = 0; i < chaptersTaken.length; i++) {
        if (chaptersTaken[i].sessionName == name) {
          chaptersTaken[i].noOfChaptersTaken--;
          return chaptersTaken;
        }
      }
      return null;
    }
  }

  // to update the number of chapter taken by a user in all sessions
  // when the user mark the taken chapter as finished
  Future updateNoOfChaptersTakenForAUserWhenMarkedFinished(
      bool increase) async {
    String chaptersTaken = await readerCollection
        .doc(uid)
        .get()
        .then((value) => value.data()['chaptersTaken']);
    List decodedChaptersTaken = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList = decodedChaptersTaken
        .map((json) => ChaptersTaken.fromJson(json))
        .toList();
    List<ChaptersTaken> modifiedChaptersTaken =
        await _updateChaptersTakenByUserWhenMarkedFinished(
            chaptersTakenList, increase);

    return await readerCollection
        .doc(uid)
        .update({'chaptersTaken': jsonEncode(modifiedChaptersTaken)});
  }

  _updateChaptersTakenByUserWhenMarkedFinished(
      List<ChaptersTaken> chaptersTaken, bool increase) {
    if (increase) {
      for (var i = 0; i < chaptersTaken.length; i++) {
        if (chaptersTaken[i].sessionName == name) {
          chaptersTaken[i].noOfChaptersTaken--;
          return chaptersTaken;
        }
      }
      return null;
    } else {
      for (var i = 0; i < chaptersTaken.length; i++) {
        if (chaptersTaken[i].sessionName == name) {
          chaptersTaken[i].noOfChaptersTaken++;
          return chaptersTaken;
        }
      }
      return null;
    }
  }

  Future populateChaptersTakenWhenJoiningSession() async {
    String chaptersTaken = await readerCollection
        .doc(uid)
        .get()
        .then((value) => value.data()['chaptersTaken']);
    List decodedChaptersTaken = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList = decodedChaptersTaken
        .map((json) => ChaptersTaken.fromJson(json))
        .toList();

    for (var i = 0; i < chaptersTakenList.length; i++) {
      if (chaptersTakenList[i].sessionName == name) {
        return null;
      }
    }

    int orderNum = await sessionCollection
        .doc(name)
        .get()
        .then((value) => value.data()['order']);

    if (chaptersTakenList[0].sessionName == '') {
      chaptersTakenList[0] = ChaptersTaken(
          sessionName: name, noOfChaptersTaken: 0, orderNum: orderNum);
    } else {
      chaptersTakenList.add(ChaptersTaken(
          sessionName: name, noOfChaptersTaken: 0, orderNum: orderNum));
      chaptersTakenList.sort((a, b) => a.orderNum.compareTo(b.orderNum));
    }
    return await readerCollection
        .doc(uid)
        .update({'chaptersTaken': jsonEncode(chaptersTakenList)});
  }

  // to update the number of chpaters finished in a session
  Future updateNoOfChaptersFinished() async {
    String chapters = await sessionCollection
        .doc(name)
        .get()
        .then((value) => value.data()['available_chapters']);
    List decodedChapters = jsonDecode(chapters);
    List<ChapterAssignment> chapterAssignmentList = decodedChapters
        .map((json) => ChapterAssignment.fromJson(json))
        .toList();
    int noOfChaptersFinished =
        _getNoOfChaptersFinishedFromChapterAssignment(chapterAssignmentList);
    return await sessionCollection
        .doc(name)
        .update({'no_of_chapters_finished': noOfChaptersFinished});
  }

  int _getNoOfChaptersFinishedFromChapterAssignment(
      List<ChapterAssignment> chapters) {
    int _noOfChaptersFinished = 0;
    for (var i = 0; i < 30; i++) {
      if (chapters[i].chapterStatus != false) {
        _noOfChaptersFinished++;
      }
    }
    return _noOfChaptersFinished;
  }

  // to update the username of chapter assigned by someone
  Future updateChapterAssignmentUsername(
      List<ChapterAssignment> chapters) async {
    return await sessionCollection
        .doc(name)
        .update({'available_chapters': jsonEncode(chapters)});
  }

  // to update the status of a chpater (finished or not)
  Future updateChapterAssignmentChapterStatus(ChapterAssignment chapter) async {
    List<ChapterAssignment> chapters =
        await _updateChapterStatusFromChapterAssignmentList(chapter, name);
    return await sessionCollection
        .doc(name)
        .update({'available_chapters': jsonEncode(chapters)});
  }

  // to reset a specific session
  Future resetChapterAssignmentPage() async {
    await resetChaptersTakenForAllUser();
    return await sessionCollection.doc(name).update({
      'available_chapters': jsonEncode(populateChapterList()),
      'no_of_chapters_finished': 0,
      'no_of_chapters_taken': 0,
    });
  }

  // to reset all chapters taken of all users in a session
  Future<void> resetChaptersTakenForAllUser() async {
    List readers = await sessionCollection
        .doc(name)
        .get()
        .then((value) => value.data()['readers']);

    for (var i = 0; i < readers.length; i++) {
      await readerCollection.doc(readers[i]).update({
        'chaptersTaken':
            await _resetSessionFromReadersCollection(readers[i], name)
      });
    }
  }

  Future<String> _resetSessionFromReadersCollection(
      String readerUid, String sessionName) async {
    String chaptersTaken = await readerCollection
        .doc(readerUid)
        .get()
        .then((value) => value.data()['chaptersTaken']);
    List decodedChapters = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList =
        decodedChapters.map((json) => ChaptersTaken.fromJson(json)).toList();
    for (var i = 0; i < chaptersTakenList.length; i++) {
      if (chaptersTakenList[i].sessionName == sessionName) {
        chaptersTakenList[i].noOfChaptersTaken = 0;
      }
    }
    return jsonEncode(chaptersTakenList);
  }

  // Checking if the user is the creator of the session
  // Future<bool> checkAuthorityOfUser() async {
  //   if (uid ==
  //       await sessionCollection
  //           .document(name)
  //           .get()
  //           .then((value) => value.data["creator"])) {
  //     return true;
  //   }
  // }

  Future<List<ChapterAssignment>> _updateChapterStatusFromChapterAssignmentList(
      ChapterAssignment chapter, String sessionName) async {
    String chapters = await sessionCollection
        .doc(sessionName)
        .get()
        .then((value) => value.data()['available_chapters']);
    List decodedChapters = jsonDecode(chapters);
    List<ChapterAssignment> chapterAssignmentList = decodedChapters
        .map((json) => ChapterAssignment.fromJson(json))
        .toList();
    int parsedChapterNo = int.parse(chapter.chapterNo);
    chapterAssignmentList[parsedChapterNo - 1].chapterStatus =
        chapter.chapterStatus;
    return chapterAssignmentList;
  }

  List<Session> _sessionsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Session(
          description: doc.data()['description'] ?? '',
          name: doc.data()['name'] ?? '',
          noOfChaptersTaken: doc.data()['no_of_chapters_taken'] ?? 0,
          noOfChaptersFinished: doc.data()['no_of_chapters_finished'] ?? 0);
    }).toList();
  }

  List<ChapterAssignment> _chaptersListFromSnapshot(DocumentSnapshot snapshot) {
    String availableChapters = snapshot.data()['available_chapters'];
    List chapters = jsonDecode(availableChapters);
    List<ChapterAssignment> chapterAssignmentList =
        chapters.map((json) => ChapterAssignment.fromJson(json)).toList();

    return chapterAssignmentList;
  }

  List<ChaptersTaken> _chaptersTakenFromSnapshot(DocumentSnapshot snapshot) {
    String chaptersTaken = snapshot.data()['chaptersTaken'];
    List decodedChaptersTaken = jsonDecode(chaptersTaken);
    List<ChaptersTaken> chaptersTakenList = decodedChaptersTaken
        .map((json) => ChaptersTaken.fromJson(json))
        .toList();

    return chaptersTakenList;
  }

  Future<String> getUsernameFromUid() async {
    return await readerCollection
        .doc(uid)
        .get()
        .then((value) => value.data()['name']);
  }

  Stream<List<Session>> get session {
    return sessionCollection
        .where('readers', arrayContains: uid)
        .orderBy('order', descending: false)
        .snapshots()
        .map(_sessionsListFromSnapshot);
  }

  Stream<List<ChapterAssignment>> get chapter {
    return sessionCollection
        .doc(name)
        .snapshots()
        .map(_chaptersListFromSnapshot);
  }

  Stream<List<ChaptersTaken>> get chapterTaken {
    return readerCollection
        .doc(uid)
        .snapshots()
        .map(_chaptersTakenFromSnapshot);
  }
}
