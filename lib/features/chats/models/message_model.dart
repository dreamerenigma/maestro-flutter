import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late final String toId;
  late final String message;
  late final bool read;
  late final String fromId;
  late final DateTime sent;

  MessageModel({
    required this.toId,
    required this.message,
    required this.read,
    required this.fromId,
    required this.sent,
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
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['message'] = message;
    data['read'] = read;
    data['fromId'] = fromId;
    data['sent'] = Timestamp.fromDate(sent);
    return data;
  }
}
