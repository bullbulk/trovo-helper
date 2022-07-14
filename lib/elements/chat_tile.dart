// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/api/utils/models.dart';

import '../const.dart';
import '../utils/getx.dart';

class ChatTile extends StatefulWidget {
  final ChatMessage chatItem;

  const ChatTile({Key? key, required this.chatItem}) : super(key: key);

  @override
  State<ChatTile> createState() => ChatTileState();
}

class ChatTileState extends State<ChatTile>
    with SingleTickerProviderStateMixin {
  ChatTileState({Key? key});

  var medals = [];

  late ChatMessage chatItem;

  @override
  void initState() {
    super.initState();

    chatItem = widget.chatItem;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Get.find<MessagesController>().newMessage(),
    ); // Call after build

    if (chatItem.medals != null) {
      for (String i in chatItem.medals as List) {
        if (i.startsWith("sub_")) {
          medals.add(const Icon(Icons.star, color: Colors.amber));
        }

        var medal = commonMedals[i];
        if (medal != null) {
          medals.add(medal);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (chatItem["avatar"] != null)
          //   CachedNetworkImage(
          //     imageUrl: "${chatItem["avatar"]}",
          //     imageBuilder: (context, imageProvider) => CircleAvatar(
          //       backgroundImage: imageProvider,
          //       radius: 16,
          //     ),
          //     placeholder: (context, url) => const CircularProgressIndicator(),
          //     width: 32,
          //     height: 32,
          //     memCacheWidth: 16,
          //     memCacheHeight: 16,
          //     maxWidthDiskCache: 16,
          //     maxHeightDiskCache: 16,
          //   ),
          // const SizedBox(
          //   width: 12,
          // ),
          ...medals,
          if (medals != []) const SizedBox(width: 6),
          SelectableText(
            chatItem.nickname,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: SelectableText(
              chatItem.content,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
