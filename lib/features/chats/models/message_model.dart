import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late final String toId;
  late final String message;
  late final bool read;
  late final String fromId;
  late final DateTime sent;
  late final List<String> deleted;

  MessageModel({
    required this.toId,
    required this.message,
    required this.read,
    required this.fromId,
    required this.sent,
    required this.deleted,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    message = json['message'].toString();
    read = json['read'] is bool ? json['read'] : json['read'] == 'true';
    fromId = json['fromId'].toString();
    if (json['sent'] is Timestamp) {
      sent = (json['sent'] as Timestamp).toDate();
    } else {
      sent = DateTime.parse(json['sent']);
    }
    deleted = List<String>.from(json['deletedBy'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['message'] = message;
    data['read'] = read;
    data['fromId'] = fromId;
    data['sent'] = Timestamp.fromDate(sent);
    data['deletedBy'] = deleted;
    return data;
  }
}
