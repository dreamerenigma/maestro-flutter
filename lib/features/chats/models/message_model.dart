class MessageModel {
  MessageModel({
    required this.toId,
    required this.msg,
    required this.read,
    required this.fromId,
    required this.sent,
    required this.deleted,
  });

  late final String toId;
  late final String msg;
  late final bool read;
  late final String fromId;
  late final DateTime sent;
  late final List<String> deleted;

  MessageModel.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'] == 'true';
    fromId = json['fromId'].toString();
    sent = DateTime.parse(json['sent']);
    deleted = List<String>.from(json['deletedBy'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read ? 'true' : 'false';
    data['fromId'] = fromId;
    data['sent'] = sent.toIso8601String();
    data['deletedBy'] = deleted;
    return data;
  }
}
