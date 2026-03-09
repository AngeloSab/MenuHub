import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repository/abstract_staff_user_repository.dart';
import '../../domain/hotel_package/staff_user.dart';
import '../../mappers/staff_user_firestore_mapper.dart';

class FirebaseStaffUserRepository implements StaffUserRepository {
  final FirebaseFirestore firestore;

  FirebaseStaffUserRepository(this.firestore);

  @override
  Future<void> save(StaffUser staffUser) async {
    await firestore
        .collection('staffUsers')
        .doc(staffUser.id)
        .set(StaffUserFirestoreMapper.toFirestore(staffUser));
  }

  @override
  Future<StaffUser?> getById(String staffUserId) async {
    final doc = await firestore
        .collection('staffUsers')
        .doc(staffUserId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return StaffUserFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data()!,
    );
  }

  @override
  Future<List<StaffUser>> getByHotel(String hotelId) async {
    final snapshot = await firestore
        .collection('staffUsers')
        .where('hotelId', isEqualTo: hotelId)
        .get();

    return snapshot.docs
        .map(
          (doc) => StaffUserFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: doc.data(),
      ),
    )
        .toList();
  }

  @override
  Stream<List<StaffUser>> watchByHotel(String hotelId) {
    return firestore
        .collection('staffUsers')
        .where('hotelId', isEqualTo: hotelId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => StaffUserFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList(),
    );
  }

  @override
  Future<StaffUser?> getByEmail(String email) async {
    final snapshot = await firestore
        .collection('staffUsers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return StaffUserFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data(),
    );
  }
}