import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/elements/message_tile.dart';
import 'package:trovo_helper/utils/getx.dart';

import '../utils/getx.dart';
import 'message_tile.dart';

const extraScrollSpeed = 80;

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ScrollController _scrollController;
  double _lastScrollPosition = .0;

  void scrollToEnd() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels == _lastScrollPosition) {
      _scrollController.jumpTo(position);
    }
    _lastScrollPosition = position;
  }

  void _setupScrollController() {
    // Increase scroll speed on mouse
    if (GetPlatform.isDesktop) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? extraScrollSpeed
                  : -extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }

    // Scroll down if current position is on the last element
    Get.find<MessagesController>().addListener(() => scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    // Scroll controller detaches with every Navigator.pop(),
    // so we need to create a new one every Navigator.push()
    _scrollController = ScrollController();
    _setupScrollController();

    return GetBuilder<BotController>(
      builder: (controller) => ListView.builder(
        controller: _scrollController,
        itemCount: controller.chatMessages.length,
        itemBuilder: (BuildContext context, int index) {
          final messageItem = controller.chatMessages[index];
          return MessageTile(
            messageItem: messageItem,
          );
        },
      ),
    );
  }
}
