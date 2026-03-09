import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/client_package/client_session.dart';
import '../../domain/repository/abstract_client_session_repository.dart';
import '../../mappers/client_session_firestore_mapper.dart';

class FirebaseClientSessionRepository implements ClientSessionRepository {
  final FirebaseFirestore firestore;

  FirebaseClientSessionRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> _clientSessionsRef(String hotelId) {
    return firestore
        .collection('hotels')
        .doc(hotelId)
        .collection('clientSessions');
  }

  @override
  Future<void> save(ClientSession clientSession) async {
    try {
      await _clientSessionsRef(clientSession.hotelId)
          .doc(clientSession.id)
          .set(ClientSessionFirestoreMapper.toFirestore(clientSession));
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in save(clientSessionId=${clientSession.id}): ${e.message}',
      );
    }
  }

  @override
  Future<ClientSession?> getById({
    required String hotelId,
    required String clientSessionId,
  }) async {
    try {
      final doc = await _clientSessionsRef(hotelId).doc(clientSessionId).get();
      final data = doc.data();
      if (data == null) return null;

      return ClientSessionFirestoreMapper.fromFirestore(
        docId: doc.id,
        data: data,
      );
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getById(hotelId=$hotelId, clientSessionId=$clientSessionId): ${e.message}',
      );
    }
  }

  @override
  Future<List<ClientSession>> getByHotel(String hotelId) async {
    try {
      final snapshot = await _clientSessionsRef(hotelId).get();

      return snapshot.docs
          .map(
            (doc) => ClientSessionFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(
        'Errore Firestore in getByHotel(hotelId=$hotelId): ${e.message}',
      );
    }
  }

  @override
  Stream<List<ClientSession>> watchByHotel(String hotelId) {
    return _clientSessionsRef(hotelId).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => ClientSessionFirestoreMapper.fromFirestore(
          docId: doc.id,
          data: doc.data(),
        ),
      )
          .toList();
    });
  }
}