import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:trovo_helper/elements/chat_tile.dart';
import 'package:trovo_helper/utils/getx.dart';

import '../utils/getx.dart';
import 'chat_tile.dart';

const extraScrollSpeed = 80;

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _scrollController = ScrollController();
  double _lastScrollPosition = .0;

  void scrollDown() {
    final position = _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels == _lastScrollPosition) {
      _scrollController.jumpTo(position);
    }
    _lastScrollPosition = position;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Increase scroll speed
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

    // Scroll down if current position is on the last element
    Get.find<MessagesController>().addListener(() => scrollDown());
    Get.find<MessagesController>().addListener(() => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BotController>(
      builder: (controller) => ListView.builder(
        controller: _scrollController,
        itemCount: controller.chatMessages.length,
        itemBuilder: (BuildContext context, int index) {
          final chatItem = controller.chatMessages[index];
          return ChatTile(
            chatItem: chatItem,
          );
        },
      ),
    );
  }
}
