import 'package:chat_wave/domain/entity/message.dart';
import 'package:chat_wave/extension/widget_extension.dart';
import 'package:flutter/widgets.dart';

import '../../shared/widget/cache_image.dart';

class MultiPartBubble extends StatelessWidget{

  final Message msg;

  const MultiPartBubble({super.key,required this.msg});

  @override
  Widget build(BuildContext context) {

    List<Widget> messageBases=[];
    for(final base in msg.pieces){
      if(base.isText){
        messageBases.add(
          Padding(
            padding: const EdgeInsets.all(9),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                base.content!,
              ),
            ),
          )
        );
      }else if(base.isImageUrl){
        messageBases.add(
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: getCustomCachedImage(
                url: base.content!,
                width: 250,
              ),
            ),
          ),
        );
      }
    }
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 270,
      decoration: BoxDecoration(
        color: msg.isSender ? context.theme.colorScheme.primaryContainer : context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.onSurface.withOpacity(0.2),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: messageBases,
      ),
    );
  }
}