import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ConcertEntity {
  final String title;
  final String artist;
  final Timestamp eventDate;
  final bool isFavorite;
  final String concertId;
  final int ticketSoldCount;
  final String venue;
  final String coverPath;

  ConcertEntity({
    required this.title,
    required this.artist,
    required this.eventDate,
    required this.isFavorite,
    required this.concertId,
    required this.ticketSoldCount,
    required this.venue,
    required this.coverPath,
  });
}

Future<ConcertEntity> convertConcertModelToEntity(SongModel songModel, {bool fetchFromFirestore = true}) async {
  int ticketSoldCount = 0;
  String venue = 'Unknown Venue';

  if (fetchFromFirestore) {
    ticketSoldCount = await _fetchTicketSoldCountFromFirestore(songModel.id.toString());
    venue = await _fetchConcertVenueFromFirestore(songModel.id.toString());
  }

  return ConcertEntity(
    title: songModel.title,
    artist: songModel.artist ?? 'Unknown Artist',
    eventDate: Timestamp.now(),
    isFavorite: false,
    concertId: songModel.id.toString(),
    ticketSoldCount: ticketSoldCount,
    venue: venue,
    coverPath: '',
  );
}

Future<int> _fetchTicketSoldCountFromFirestore(String concertId) async {
  final doc = await FirebaseFirestore.instance.collection('Concerts').doc(concertId).get();
  return doc.exists ? (doc.data()?['ticketSoldCount'] ?? 0) as int : 0;
}

Future<String> _fetchConcertVenueFromFirestore(String concertId) async {
  final doc = await FirebaseFirestore.instance.collection('Concerts').doc(concertId).get();
  return doc.exists ? (doc.data()?['venue'] ?? 'Unknown Venue') as String : 'Unknown Venue';
}
