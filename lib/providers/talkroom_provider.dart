import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thanks_diary/models/thanks.dart';
import 'package:thanks_diary/providers/users_provider.dart';

import '../allConstants/all_Constants.dart';
import '../models/room.dart';
import '../models/user.dart';
import 'auth_provider.dart';
import 'firebase_provider.dart';

///ユーザーはログインしてるし、TalkroomIdはなかったら作る。//talkroomidはnullの場合がある。
final talkroomIdProvider = FutureProvider<String>((ref) async {
  final firestore = ref.read(firestoreProvider);
  final String? uid = ref.watch(uidProvider);

  final appUserRef = ref.watch(currentAppUserDocRefProvider);

  if (uid == null) {
    throw Exception('ログインしていません。');
  }
  final appUserDoc = await ref.watch(currentAppUserDocRefProvider).get();

  String getTalkroomId(String? talkroomId, DocumentSnapshot<AppUser> UserDoc) {
    if (talkroomId != null) {
      return UserDoc.get(Consts.talkroomId)!;
    } else {
      appUserRef.update({Consts.talkroomId: uid});
      return appUserDoc.get(Consts.talkroomId)!;
    }
  }

  if (appUserDoc.exists) {
    final String? talkroomId = appUserDoc.get(Consts.talkroomId);
    return getTalkroomId(talkroomId, appUserDoc);
  }

  ///ユーザーDocがないときはDocを作成後talkroomIdを取得。
  else {
    final newUser = AppUser(
        id: uid,
        photoUrl: 'Girl',
        displayName: 'かな',
        updateAt: null,
        partnerName: '',
        talkroomId: uid,
        chtattingWith: 'P18KIdVBUqdcqVGyJt6moTLoONf2',
        whatNow: 'SleepGirl1.png',
        fcmToken: '',
        isGirl: true);
    await appUserRef.set(newUser);
    final userReDocumentSnapshot =
        await ref.watch(currentAppUserDocRefProvider).get();
    final String talkroomId = userReDocumentSnapshot.get(Consts.talkroomId);
    return getTalkroomId(talkroomId, userReDocumentSnapshot);
  }
});

final talkroomDocProvider = FutureProvider((ref) async {
  final firestore = ref.read(firestoreProvider);
  final String? talkroomId = ref.watch(talkroomIdProvider).value;
  final tallkroomRef = ref.watch(talkroomReferenceProvider).value;

  if (talkroomId == null || tallkroomRef == null) {
    return null;
  }
  final talkDocroomRef = firestore.collection(Consts.talkrooms).doc(talkroomId);
  final talkroomDoc = await talkDocroomRef.get();

  if (talkroomDoc.data()?['version'] == null) {
    talkDocroomRef.update({'version': 0});
  }
  if (talkroomDoc.data()?['lastRoomIndex'] == null) {
    talkDocroomRef.update({'lastRoomIndex': 1});
  }
  final dateRoomRef = talkDocroomRef.collection('rooms').doc('date');
  final dateRoom = await dateRoomRef.get();
  if (dateRoom.exists == false) {
    final _dateroom = Room(
        roomname: 'デートの',
        roomId: 'date',
        description: '行きたいところをメモしておきましょう。\nこんなことがしたい、を書いておくのも〇。',
        roomIndex: 2,
        reference: talkDocroomRef.collection(Consts.rooms).doc('date'));
    dateRoomRef.set(_dateroom.toJson());
  }
  final myRoomRef = talkDocroomRef.collection('rooms').doc('my');
  final myRoom = await myRoomRef.get();
  if (myRoom.exists) {
    myRoomRef.delete();
  }

  return talkroomDoc;
});

final talkroomReferenceProvider = FutureProvider((ref) async {
  final firestore = ref.read(firestoreProvider);
  final uid = ref.watch(uidProvider);
  final String? talkroomId = ref.watch(talkroomIdProvider).value;
  final talkDocroomRef = firestore.collection(Consts.talkrooms).doc(talkroomId);
  final talkroomDoc = await talkDocroomRef.get();
  // final partner = ref.watch(partnerUserDocProvider).value;

  // final partnerUid = partner?.id ?? 'P18KIdVBUqdcqVGyJt6moTLoONf2';
  final partnerUid = 'P18KIdVBUqdcqVGyJt6moTLoONf2';
  if (talkroomId == null) {
    return null;
  }

  ///talkroomDocが存在しないときに、talkroomを生成。
  void talkroomsetter() {
    talkDocroomRef.set({
      'users': [uid],
      'lastRoomIndex': 1,
      'version': 0
    });
    talkDocroomRef.collection(Consts.posts).doc();
    final initRef = talkDocroomRef.collection("thanks").doc();
    final initThanks = Thanks(
        date: Timestamp.now(),
        message: "",
        category: "",
        posterId: "",
        posterName: "",
        reference: initRef);
    initRef.set(initThanks.toJson());
  }

  if (talkroomDoc.exists) {
    final initRoomRef = talkDocroomRef.collection('rooms').doc('init');
    // final initRoom = await initRoomRef.get();
    // final initRoomName = initRoom.get('roomname');
    // if (initRoomName == '日常会話の部屋') {
    //   initRoomRef.update({'roomname': '日常会話の', 'roomIndex': 0});
    // }
    // final tweetRoomRef = talkDocroomRef.collection('rooms').doc('tweet');
    // final tweetRoom = await tweetRoomRef.get();
    // final tweetRoomName = tweetRoom.get('roomname');
    // if (tweetRoomName == 'つぶやきの部屋') {
    //   tweetRoomRef.update({'roomname': 'つぶやきの', 'roomIndex': 0});
    // }
    // final hobbyRoomRef = talkDocroomRef.collection('rooms').doc('hobby');
    // final hobbyRoom = await hobbyRoomRef.get();
    // final hobbyRoomName = hobbyRoom.get(
    //   'roomname',
    // );
    // if (hobbyRoomName == '趣味を語る部屋') {
    //   hobbyRoomRef.update({'roomname': '趣味を語る', 'roomIndex': 1});
    // }
    return talkDocroomRef;
  } else {
    print('tester');
    talkroomsetter();
    final retalkDocroomRef =
        await firestore.collection(Consts.talkrooms).doc(talkroomId);
    return retalkDocroomRef;
  }
});

final lastRoomIndexProvider = FutureProvider<int>((ref) async {
  final currentTalkroomSnapshot =
      await ref.watch(talkroomReferenceProvider).value?.get();
  final int lastRoomIndex = currentTalkroomSnapshot?.get('lastRoomIndex') ?? 1;

  return lastRoomIndex;
});
