import '../../domain/entity/chat_session.dart';
import '../../domain/entity/message.dart';

class TestUIData{

  List<ChatSession> sessions = [
    ChatSession(
      sessionId: 1,
      userId: 10004,
      title: 'Chat Session 1',
      lastMsgTime: DateTime(2024, 5, 21),
    ),
    ChatSession(
      sessionId: 2,
      userId: 10004,
      title: 'Chat Session 2',
      lastMsgTime: DateTime(2024, 5, 20),
    ),
    ChatSession(
      sessionId: 3,
      userId: 10004,
      title: 'Chat Session 3',
      lastMsgTime: DateTime(2024, 5, 19),
    ),
    ChatSession(
      sessionId: 4,
      userId: 10004,
      title: 'Chat Session 4',
      lastMsgTime: DateTime(2024, 5, 18),
    ),
    ChatSession(
      sessionId: 5,
      userId: 10004,
      title: 'Chat Session 5',
      lastMsgTime: DateTime(2024, 5, 17),
    ),
    ChatSession(
      sessionId: 6,
      userId: 10004,
      title: 'Chat Session 6',
      lastMsgTime: DateTime(2024, 5, 16),
    ),
    ChatSession(
      sessionId: 7,
      userId: 10004,
      title: 'Chat Session 7',
      lastMsgTime: DateTime(2024, 5, 15),
    ),
    ChatSession(
      sessionId: 8,
      userId: 10004,
      title: 'Chat Session 8',
      lastMsgTime: DateTime(2024, 5, 14),
    ),
    ChatSession(
      sessionId: 9,
      userId: 10004,
      title: 'Chat Session 9',
      lastMsgTime: DateTime(2023, 12, 25),
    ),
    ChatSession(
      sessionId: 10,
      userId: 10004,
      title: 'Chat Session 10',
      lastMsgTime: DateTime(2023, 8, 14),
    ),
    ChatSession(
      sessionId: 11,
      userId: 10004,
      title: 'Chat Session 11',
      lastMsgTime: DateTime(2023, 3, 1),
    ),
    ChatSession(
      sessionId: 12,
      userId: 10004,
      title: 'Chat Session 12',
      lastMsgTime: DateTime(2022, 11, 11),
    ),
    ChatSession(
      sessionId: 13,
      userId: 10004,
      title: 'Chat Session 13',
      lastMsgTime: DateTime(2022, 6, 30),
    ),
    ChatSession(
      sessionId: 14,
      userId: 10004,
      title: 'Chat Session 14',
      lastMsgTime: DateTime(2022, 1, 20),
    ),
    ChatSession(
      sessionId: 15,
      userId: 10004,
      title: 'Chat Session 15',
      lastMsgTime: DateTime(2021, 12, 5),
    ),
    ChatSession(
      sessionId: 16,
      userId: 10004,
      title: 'Chat Session 16',
      lastMsgTime: DateTime(2021, 7, 19),
    ),
    ChatSession(
      sessionId: 17,
      userId: 10004,
      title: 'Chat Session 17',
      lastMsgTime: DateTime(2021, 3, 15),
    ),
    ChatSession(
      sessionId: 18,
      userId: 10004,
      title: 'Chat Session 18',
      lastMsgTime: DateTime(2020, 10, 10),
    ),
    ChatSession(
      sessionId: 19,
      userId: 10004,
      title: 'Chat Session 19',
      lastMsgTime: DateTime(2020, 5, 21),
    ),
    ChatSession(
      sessionId: 20,
      userId: 10004,
      title: 'Chat Session 20',
      lastMsgTime: DateTime(2019, 8, 30),
    ),
    ChatSession(
      sessionId: 21,
      userId: 10004,
      title: 'Chat Session 21',
      lastMsgTime: DateTime(2018, 4, 5),
    ),
  ];
  List<Message> messages = [
    Message(
      sessionId: 1001,
      role: true,  // 用户发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "Hello, how are you?")
      ],
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      sessionId: 1001,
      role: false,  // 模型发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "I'm fine, thank you!")
      ],
      time: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    Message(
      sessionId: 1001,
      role: true,  // 用户发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "Give me a picture of a cat，it should have multiple color")
      ],
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      sessionId: 1001,
      role: false,  // 模型发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "Nice Idea! Here you are. "),
        MessageBase(type: MessageType.imageUrl, content: 'https://img0.baidu.com/it/u=3933681069,484251600&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800'),
      ],
      time: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Message(
      sessionId: 1001,
      role: true,  // 用户发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "Thank you!")
      ],
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Message(
      sessionId: 1001,
      role: true,  // 模型发送
      pieces: [
        MessageBase(type: MessageType.pureText, content: "Nice Idea! Here you are. "),
        MessageBase(type: MessageType.imageUrl, content: 'https://img0.baidu.com/it/u=3933681069,484251600&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800'),
      ],
      time: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];
}