// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/api/utils/models.dart';
import 'package:trovo_helper/elements/message_content.dart';
import 'package:trovo_helper/utils/images.dart';
import 'package:trovo_helper/utils/getx.dart';

class MessageTile extends StatelessWidget {
  final MessageItem messageItem;

  const MessageTile({Key? key, required this.messageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Get.find<MessagesController>().newMessage(),
    );

    var medalsRow = [];

    if (messageItem.medals != null) {
      for (String i in messageItem.medals as List) {
        var medal = medalsWidgets[i];
        if (medal != null) {
          medalsRow.add(SizedBox(
            width: 20,
            height: 20,
            child: medal,
          ));
          medalsRow.add(const SizedBox(width: 4));
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memory consumption is too high
          //
          // if (messageItem.avatar != null)
          //   CachedNetworkImage(
          //     imageUrl: "${messageItem.avatar}",
          //     imageBuilder: (context, imageProvider) => CircleAvatar(
          //       backgroundImage: imageProvider,
          //       radius: 16,
          //     ),
          //     placeholder: (context, url) => const CircularProgressIndicator(),
          //     width: 24,
          //     height: 24,
          //     memCacheWidth: 24,
          //     memCacheHeight: 24,
          //     maxWidthDiskCache: 24,
          //     maxHeightDiskCache: 24,
          //   ),
          // const SizedBox(
          //   width: 8,
          // ),
          ...medalsRow,
          if (medalsRow != []) const SizedBox(width: 4),
          SelectableText(
            messageItem.nickname,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: getMessageContentWidget(messageItem),
          )
        ],
      ),
    );
  }
}
