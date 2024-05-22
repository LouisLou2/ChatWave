import 'package:chat_wave/constant/test_data.dart';

import '../../../domain/entity/chat_session.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/entity/message_piece.dart';

class ChatHistoryStateRep {
  late ChatSession nowSession;
  List<Message> messages = [];

  bool lastMessageEnd = true;

  // 一定是给model信息用的
  void appendNewMessagePiece(MessagePiece piece) {

    assert(!(piece.type==MessageType.waitingSign && !lastMessageEnd));
    assert(!(piece.type==MessageType.cancelSign && lastMessageEnd && messages.last.pieces.last.type!=MessageType.waitingSign));

    if(piece.type==MessageType.waitingSign){
      messages.add(
        Message(
          sessionId: nowSession.sessionId,
          role: false,
          pieces: [MessageBase.fromPiece(piece)],
          time: DateTime.now(),
        ),
      );
      return;
    }
    // 将cancel消息转化为普通的pureText消息
    if(piece.type==MessageType.cancelSign){
      piece = MessagePiece.toPureText(piece: piece, isEnd: true);
    }

    if(lastMessageEnd){
      // 在第一条消息到来之前，已经添加以一条消息waiting，这里正好使用它
      assert(messages.isNotEmpty && messages[0].pieces.isNotEmpty);

      messages.last.time=DateTime.now();
      messages.last.pieces=[MessageBase(
        type: MessageType.pureText,
        content: piece.content,
      )];
      if(!piece.isEnd)lastMessageEnd = false;
      return;
    }

    if(piece.isEnd) lastMessageEnd=true;
    if(messages.last.pieces.last.type==MessageType.pureText){
      if(piece.type==MessageType.pureText){
        messages.last.pieces.last.content=messages.last.pieces.last.content!+piece.content;
      }else if(piece.type==MessageType.cancelSign){
        messages.last.pieces.last.content='${messages.last.pieces.last.content!}\n${piece.content}';
      }
      return;
    }
    messages.last.pieces.add(
      MessageBase.fromPiece(piece),
    );
  }
  void onTheMessageOver(){
    lastMessageEnd=true;
  }
  /*调用此方法前，nowSession应该已经被设置过了*/
  void initHistory(List<Message> msgs) {
    messages = msgs;
    lastMessageEnd=true;
  }

  void setNowSession(ChatSession session) {
    nowSession = session;
  }

  void addHistoryMessages(List<Message> msgs) {
    messages.insertAll(0, msgs);
  }

  void addNewMessage(Message msg){
    messages.add(msg);
  }

  /* 在发起第一次对话的时候，一旦流被打开，就要将用户的第一条消息显示在屏幕上，这里也就是messages中，但是此时
  * 这个session的信息还没有拿到，也就是第一条消息实际上是没有sessionId的，所以要在这里设置sessionId，因为它一定在第一条，所以比较好设计
  * */
  void setSessionIdForTmpMsg(){
    assert(messages.isNotEmpty);
    messages[0].sessionId=nowSession.sessionId;
  }

  void clear(){
    nowSession = ChatSession(
      sessionId: -1,
      userId: TestData.testUserId,
      lastMsgTime: DateTime.now(),
      title: 'New(Error If You See This)',
    );
    messages.clear();
    lastMessageEnd=true;
  }
}