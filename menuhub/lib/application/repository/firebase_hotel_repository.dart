import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/hotel_package/hotel.dart' as domain;
import '../../domain/repository/abstract_hotel_repository.dart';
import '../../mappers/hotel_firestore_mapper.dart';

class FirebaseHotelRepository implements HotelRepository {
  final FirebaseFirestore firestore;

  FirebaseHotelRepository(this.firestore);

  @override
  Future<void> save(domain.Hotel hotel) async {
    await firestore
        .collection('hotels')
        .doc(hotel.hotelId)
        .set(HotelFirestoreMapper.toFirestore(hotel));
  }

  @override
  Future<domain.Hotel?> getById(String hotelId) async {
    final doc = await firestore
        .collection('hotels')
        .doc(hotelId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return HotelFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data()!,
    );
  }

  @override
  Future<domain.Hotel?> getByJoinCode(String hotelJoinCode) async {
    final snapshot = await firestore
        .collection('hotels')
        .where('hotelJoinCode', isEqualTo: hotelJoinCode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return HotelFirestoreMapper.fromFirestore(
      docId: doc.id,
      data: doc.data(),
    );
  }

  @override
  Future<List<domain.Hotel>> getAll() async {
    final snapshot = await firestore
        .collection('hotels')
        .get();

    return snapshot.docs
        .map(
          (doc) => HotelFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: doc.data(),
      ),
    )
        .toList();
  }

  @override
  Stream<List<domain.Hotel>> watchAll() {
    return firestore
        .collection('hotels')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => HotelFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList(),
    );
  }
}