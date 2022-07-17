import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trovo_helper/api/utils/models.dart';

const messageContentConstructors = {
  0: NormalMessage.new,
  5: SpellMessage.new,
  6: MagicSuperCapMessage.new,
  7: MagicColorfulMessage.new,
  8: MagicSpellMessage.new,
  9: MagicBulletMessage.new,
  5001: SubscriptionMessage.new,
  5002: SystemMessage.new,
  5003: FollowMessage.new,
  5004: WelcomeMessage.new,
  5005: RandomGiftSubMessage.new,
  5006: TargetedGiftSubMessage.new,
  5007: ActivityMessage.new,
  5008: WelcomeRaidMessage.new,
  5009: CustomSpellMessage.new,
  5012: StreamStatusMessage.new,
  5013: UnfollowMessage.new,
};

Widget getMessageContentWidget(MessageItem messageItem) {
  var constructor = messageContentConstructors[messageItem.type];
  if (constructor == null) {
    return NormalMessage(messageItem: messageItem);
  }
  return constructor(messageItem: messageItem);
}

class NormalMessage extends StatelessWidget {
  final MessageItem messageItem;

  const NormalMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class SpellMessage extends StatelessWidget {
  final MessageItem messageItem;

  const SpellMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    var content = jsonDecode(messageItem.content);

    return Row(
      children: [
        SelectableText(
          "Casted ${content["gift"]} ${content["gift_value"]} x${content["num"]}",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class MagicSuperCapMessage extends StatelessWidget {
  final MessageItem messageItem;

  const MagicSuperCapMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class MagicColorfulMessage extends StatelessWidget {
  final MessageItem messageItem;

  const MagicColorfulMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class MagicSpellMessage extends StatelessWidget {
  final MessageItem messageItem;

  const MagicSpellMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class MagicBulletMessage extends StatelessWidget {
  final MessageItem messageItem;

  const MagicBulletMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class SubscriptionMessage extends StatelessWidget {
  final MessageItem messageItem;

  const SubscriptionMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class SystemMessage extends StatelessWidget {
  final MessageItem messageItem;

  const SystemMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class FollowMessage extends StatelessWidget {
  final MessageItem messageItem;

  const FollowMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class WelcomeMessage extends StatelessWidget {
  final MessageItem messageItem;

  const WelcomeMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class RandomGiftSubMessage extends StatelessWidget {
  final MessageItem messageItem;

  const RandomGiftSubMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class TargetedGiftSubMessage extends StatelessWidget {
  final MessageItem messageItem;

  const TargetedGiftSubMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class ActivityMessage extends StatelessWidget {
  final MessageItem messageItem;

  const ActivityMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class WelcomeRaidMessage extends StatelessWidget {
  final MessageItem messageItem;

  const WelcomeRaidMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class CustomSpellMessage extends StatelessWidget {
  final MessageItem messageItem;

  const CustomSpellMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class StreamStatusMessage extends StatelessWidget {
  final MessageItem messageItem;

  const StreamStatusMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class UnfollowMessage extends StatelessWidget {
  final MessageItem messageItem;

  const UnfollowMessage({super.key, required this.messageItem});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageItem.content,
      style: const TextStyle(fontSize: 16),
    );
  }
}
