import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thanks_diary/providers/auth_provider.dart';
import 'package:thanks_diary/providers/talkroom_provider.dart';
import 'package:thanks_diary/providers/users_provider.dart';

void incrementActivity(WidgetRef ref, String type) async {
  final talkroomId = ref.watch(talkroomIdProvider).value ?? '';
  final userDoc = ref.watch(CurrentAppUserDocProvider).value;
  final String userName = userDoc?.get('displayName') ?? '';
  final uid = ref.watch(uidProvider);
  if (uid == null) return null;
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  String date = outputFormat.format(now);
  Timestamp.now().toDate();
  final docRef = FirebaseFirestore.instance
      .collection('activity')
      .doc(date)
      .collection('talkrooms')
      .doc(talkroomId);
  final doc = await docRef.get();
  if (doc.exists == false) {
    final docData = {
      uid: {'userName': userName, 'chat': 0, 'tweet': 0, 'room': 0, 'home': 0}
    };
    docRef.set(docData);
  }
  if (doc.data()?[uid] == null) {
    final docData = {
      uid: {'userName': userName, 'chat': 0, 'tweet': 0, 'room': 0, 'home': 0}
    };
    docRef.update(docData);
  }
  docRef.update({'${uid}.${type}': FieldValue.increment(1)});
}
