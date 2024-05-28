import 'package:animate_do/animate_do.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_wave/extension/widget_extension.dart';
import 'package:chat_wave/feature/chat/widget/multipart_bubble.dart';
import 'package:chat_wave/feature/shared/widget/cache_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/message.dart';

class ChatBubble extends StatelessWidget{

  final Message msg;
  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    Widget innerWidget;
    if(msg.justText){
      innerWidget = BubbleNormal(
        color: msg.isSender ? context.theme.colorScheme.primaryContainer : context.theme.colorScheme.surface,
        textStyle: context.theme.textTheme.bodyMedium!.copyWith(
          color: msg.isSender ? context.theme.colorScheme.onPrimaryContainer : context.theme.colorScheme.onSurface,
        ),
        text: msg.pieces[0].content!,
        isSender: msg.isSender,
      );
    }
    else {
      innerWidget = MultiPartBubble(msg: msg);
    }
    // return msg.isSender ? FadeInRight(
    //   duration: const Duration(milliseconds: 300),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 5),
    //     child:Align(
    //       alignment: Alignment.centerRight,
    //       child: innerWidget,
    //     ),
    //   ),
    // ): FadeInLeft(
    //   duration: const Duration(milliseconds: 300),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 5),
    //     child:Align(
    //       alignment: Alignment.centerLeft,
    //       child: innerWidget,
    //     ),
    //   ),
    // );
    return msg.isSender ? FadeInRight(child:
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child:Align(
            alignment: Alignment.centerRight,
            child: innerWidget,
          ),
        )
      ):
      FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child:Align(
          alignment: Alignment.centerLeft,
          child: innerWidget,
        ),
      ),
    );
  }
}