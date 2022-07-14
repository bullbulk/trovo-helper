const models = {
  0: NormalMessage,
  5: SpellMessage,
  6: MagicSuperCapMessage,
  7: MagicColorfulMessage,
  8: MagicSpellMessage,
  9: MagicBulletMessage,
  5001: SubscriptionMessage,
  5002: SystemMessage,
  5003: FollowMessage,
  5004: WelcomeMessage,
  5005: RandomGiftSubMessage,
  5006: TargetedGiftSubMessage,
  5007: ActivityMessage,
  5008: WelcomeRaidMessage,
  5009: CustomSpellMessage,
  5012: StreamStatusMessage,
  5013: UnfollowMessage,
};

class ChatMessage {
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

  ChatMessage(
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

  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(
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

class NormalMessage {}

class SpellMessage {}

class MagicSuperCapMessage {}

class MagicColorfulMessage {}

class MagicSpellMessage {}

class MagicBulletMessage {}

class SubscriptionMessage {}

class SystemMessage {}

class FollowMessage {}

class WelcomeMessage {}

class RandomGiftSubMessage {}

class TargetedGiftSubMessage {}

class ActivityMessage {}

class WelcomeRaidMessage {}

class CustomSpellMessage {}

class StreamStatusMessage {}

class UnfollowMessage {}
