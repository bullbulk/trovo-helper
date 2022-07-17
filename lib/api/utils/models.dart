class MessageItem {
  int type;
  String content;
  String nickname;
  Uri? avatar;
  String? subLvl;
  String? subTier;
  List? medals;
  List? decos;
  List? roles;
  String messageId;
  int senderId;
  DateTime sendTime;
  int? userId;
  String? username;
  Map? contentData;
  List<String>? customRoles;

  MessageItem(
    this.type,
    this.content,
    this.nickname,
    this.avatar,
    this.subLvl,
    this.subTier,
    this.medals,
    this.decos,
    this.roles,
    this.messageId,
    this.senderId,
    this.sendTime,
    this.userId,
    this.username,
    this.contentData,
    this.customRoles,
  );

  factory MessageItem.fromMap(Map data) {
    return MessageItem(
      data["type"],
      data["content"],
      data["nick_name"],
      Uri.parse(data["avatar"]),
      data["sub_lv"],
      data["sub_tier"],
      data["medals"],
      data["decos"],
      data["roles"],
      data["message_id"],
      data["sender_id"],
      DateTime.fromMillisecondsSinceEpoch(data["send_time"]),
      data["user_id"],
      data["user_name"],
      data["content_data"],
      data["custom_roles"],
    );
  }
}
