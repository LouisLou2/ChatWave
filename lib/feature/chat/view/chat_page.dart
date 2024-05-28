import 'package:chat_wave/domain/entity/chat_session.dart';
import 'package:chat_wave/extension/widget_extension.dart';
import 'package:chat_wave/feature/chat/bloc/chat_history_bloc.dart';
import 'package:chat_wave/feature/chat/bloc/chat_session_bloc.dart';
import 'package:chat_wave/feature/chat/widget/chat_bubble.dart';
import 'package:chat_wave/feature/main/bloc/homepage_load_bloc.dart';
import 'package:chat_wave/helper/format_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../constant/assets_const.dart';
import '../../../domain/entity/message.dart';
import '../../../helper/time_util.dart';
import '../../../router/navigation_helper.dart';
import '../../../style/app_colors.dart';
import '../../../ui/widget/backgroud_curves_painter.dart';
import '../bloc/chating_action_bloc.dart';
import '../repository/chat_history_rep.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> with SingleTickerProviderStateMixin  {

  var customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(style: BorderStyle.none)
  );

  late AnimationController _controller;

  late Animation<Offset> _offsetAnimation1;

  bool isNowEditting=false;

  late TextEditingController _textController;

  late ScrollController _historyScrollCtrl;
  late ScrollController _sessionScrollCtrl;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _historyScrollCtrl = ScrollController();
    _sessionScrollCtrl = ScrollController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation1 = Tween<Offset>(
      begin: const Offset(0.7, 0.0), // 从屏幕外的右边开始
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.4, 1.0,
        curve: Curves.easeIn,
      ),
    ));
    initScroll();
  }

  void initScroll(){

    // 当页面构建完毕，scroll到最下方
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // 滑动到最顶部就开始请求
      _historyScrollCtrl.addListener(() {
        if (_historyScrollCtrl.position.pixels == _historyScrollCtrl.position.minScrollExtent) {
          GetIt.I<ChatHistoryBloc>().add(const RetrieveChatHistory());
        }
      });
      Future.delayed(const Duration(milliseconds: 300),(){
        if(_historyScrollCtrl.hasClients){
          _historyScrollCtrl.animateTo(
            _historyScrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });

      _sessionScrollCtrl.addListener(() {
        if (_sessionScrollCtrl.position.pixels == _sessionScrollCtrl.position.minScrollExtent) {
          // 当滚动位置到达底部时，调用你的函数
          GetIt.I<ChatHistoryBloc>().add(const RetrieveChatHistory());
        }
      });
      Future.delayed(const Duration(milliseconds: 300),(){
        if(_sessionScrollCtrl.hasClients){
          _sessionScrollCtrl.animateTo(
            _sessionScrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _historyScrollCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        width: 350,
        elevation: 3,
        backgroundColor: context.theme.colorScheme.background,
        shadowColor: context.theme.colorScheme.onSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -250,
              top: -350,
              child: Container(
                height: 600,
                width: 550,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.oilGreen.withOpacity(0.3),
                      context.theme.colorScheme.background.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,top: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chat History',
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              color: context.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your web records will be synced.',
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              color: context.theme.colorScheme.outline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10,top: 50),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if(isNowEditting)_controller.reset();
                            isNowEditting=!isNowEditting;
                            Future.delayed(const Duration(milliseconds: 60),(){
                              if(isNowEditting)_controller.forward();
                            });
                          });
                        },
                        icon: Icon(
                          Icons.edit_note_rounded,
                          size: 35,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: RefreshIndicator(
                    child: BlocBuilder<ChatSessionBloc, ChatSessionState>(
                      buildWhen: (previous, current) {
                        return current is! ChatSessionFailure;
                      },
                      builder: (context, state){
                        return ListView(
                          controller: _sessionScrollCtrl,
                          padding: EdgeInsets.zero,
                          children:[
                              ..._getHistoryList(
                              sessions: context.read<ChatSessionStateRep>().sessions,
                              nowSession: 0,
                              isEditing: isNowEditting,
                              onRemove: (index) {},
                            ),
                            if(state is ChatSessionLoading)
                              const Center(child: CircularProgressIndicator()),
                          ],
                        );
                      },
                    ),
                    onRefresh: (){ return Future.delayed(const Duration(seconds: 4)); },
                  ),
                ),
                const Divider(thickness: 0.8,),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.theme.colorScheme.onSurface.withOpacity(0.8),
                    child: Image.asset(
                      AssetsConst.aiStarPic,
                      scale: 23,
                      color: context.theme.colorScheme.surface,
                    ),
                  ),
                  title: const Text('Test Account'),
                  onTap: () {},
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: context.theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                TextFormField(
                  controller: _textController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: customBorder,
                    enabledBorder:customBorder,
                    focusedBorder:customBorder,
                    focusedErrorBorder: customBorder,
                    errorBorder: customBorder,
                    hintText: 'Message',
                    filled: true,
                    //隐藏下划线
                    //border: InputBorder.none,
                    hintStyle: const TextStyle(fontSize: 15, color: Color(0xffAEAEAE)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ),
            ),
            BlocBuilder<ChatActionBloc,ChatActionState>(
              buildWhen: (previous, current) {
                return current != previous;//仅当状态改变时重建
              },
              builder: (context, state){

                VoidCallback onTap = (){};
                IconData icon = Icons.accessible_forward_outlined;

                if(state is ReceivingPieces){
                  onTap = cancelAnswer;
                }else if (state is WaitingForFirstQuery || state is WaitingForQuery) {
                  onTap=(){
                    sendQuery(query: _textController.text, isFirst: state is WaitingForFirstQuery);
                    _textController.clear();
                  };
                }
                if(state is WaitingForFirstQuery || state is WaitingForQuery||state is ReceivingPieces){
                  if(state is WaitingForFirstQuery || state is WaitingForQuery) {
                    icon = CupertinoIcons.arrow_up_circle_fill;
                  }else if(state is ReceivingPieces){
                    icon = Icons.cancel;
                  }
                  return InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Icon(
                        icon,
                        // color: context.theme.colorScheme.onSurface,
                        size: 33,
                      ),
                    ),
                  );
                }else if(state is WaitingForStream){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:SizedBox(
                      height: 27,
                      width: 27,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(context.theme.colorScheme.onSurface),
                      ),
                    ),
                  );
                }else{
                  return Icon(
                    icon,
                    size: 33,
                    color: context.theme.colorScheme.onSurface.withOpacity(0.5),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: -300,
            top: -100,
            child: Container(
              height: 600,
              width: 550,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.oilGreen.withOpacity(0.3),
                    context.theme.colorScheme.background.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: BackgroundCurvesPainter(context.theme.colorScheme.onSurface),
            size: Size.infinite,
          ),
          Column(
            children: [
              const SizedBox(height: 30,),
              LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () {
                          GetIt.I<ChatSessionBloc>().add(InitRetrieveSession(
                              nowSessionId: GetIt.I<ChatHistoryStateRep>().nowSession.sessionId
                          ));
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.menu_rounded,
                          size: 25,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () {
                            NavigationHelper.pop();
                            GetIt.I<HomePageLoadBloc>().add(const StartLoadHomePage());
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                            offset: const Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Personal AI Buddy',
                            style: TextStyle(
                              color: context.theme.colorScheme.background,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            AssetsConst.aiStarPic,
                            scale: 23,
                            color: context.theme.colorScheme.surface,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth/8,),
                  ],
                );
              }),
              Expanded(
                child: BlocBuilder<ChatActionBloc, ChatActionState>(
                  buildWhen: (previous, current) {
                    // return current is StreamOpened || current is MsgPieceArrived;
                    return previous != current || (previous==current&&previous is ReceivingPieces);
                  },
                  builder: (context, state){
                    return BlocBuilder<ChatHistoryBloc,ChatHistoryState>(
                      buildWhen: (previous, current) {
                        return current is! ChatHistoryFailure;
                      },
                      builder: (context, state){
                        List<Message> messages = context.read<ChatHistoryStateRep>().messages;
                        return (state is! ChatHistoryLoading) ?
                        ListView.builder(
                          controller: _historyScrollCtrl,
                          itemCount: messages.length+1,
                          itemBuilder: (context, index){
                            if(index==messages.length){
                              return const SizedBox(height: 100);
                            }
                            return ChatBubble(msg: messages[index]);
                          }
                        ):
                        ListView.builder(
                          controller: _historyScrollCtrl,
                          itemCount: messages.length+2,
                          itemBuilder: (context, index){
                            if(index==0){
                              return const SizedBox(height: 100);
                            }
                            if(index==messages.length+1){
                              return const SizedBox(height: 100);
                            }
                            return ChatBubble(
                              msg: messages[index-1],
                            );
                          }
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _getHistoryList({required List<ChatSession>sessions, required int nowSession, required bool isEditing, required void Function(int) onRemove}){
    DateTime now = DateTime.now();
    List<Widget> list=[];
    bool addedToday = false;
    bool addedPrivious7Days = false;
    bool longAgoAdded = false;

    for(int i=0;i<sessions.length;++i){
      final session=sessions[i];

      if(TimeUtil.sameDay(now,session.lastMsgTime)) {
        if(!addedToday){
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
              child:Text(
                'Today',
                style: context.theme.textTheme.titleMedium,
              ),
            ),
          );
          addedToday = true;
        }
        list.add(_getHistoryWidget(session, i==nowSession, isEditing, ()=>onRemove(i)));
        continue;
      }

      if(TimeUtil.inPrevious7Days(session.lastMsgTime)) {
        if(!addedPrivious7Days){
          list.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
              child: Text(
                'Previous 7 days',
                style: context.theme.textTheme.titleMedium,
              ),
            ),
          );
          addedPrivious7Days = true;
        }
        list.add(_getHistoryWidget(session, i==nowSession, isEditing, ()=>onRemove(i)));
        continue;
      }
      if(!longAgoAdded){
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
            child: Text(
              'Long Ago',
              style: context.theme.textTheme.titleMedium,
            ),
          ),
        );
        longAgoAdded = true;
      }
      list.add(_getHistoryWidget(session, i==nowSession, isEditing, ()=>onRemove(i)));
    }
    return list;
  }

  Widget _getHistoryWidget(ChatSession session,bool selected,bool isEditing, VoidCallback onRemove){
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 6, 0, 6),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: selected ? context.theme.colorScheme.surfaceVariant: Colors.transparent,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        session.title,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        )
                      ),
                    ),
                    Text(
                      FormatTool.getHistoryStr(session.lastMsgTime),
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
        isEditing?
          SlideTransition(
            position: _offsetAnimation1,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                CupertinoIcons.delete_simple,
                color: AppColors.rustyRed,
              ),
            ),
          ):const SizedBox(width: 15,),
      ],
    );
  }
  /*-------------------------Function Area----------------------------*/
  void sendQuery({
    required String query,
    required bool isFirst,
  }){
    if(query.isEmpty)return;
    GetIt.I<ChatActionBloc>().add(
      isFirst? SendFirstQuery(query): SendQuery(
          query,
          GetIt.I<ChatHistoryStateRep>().nowSession.sessionId,
      ),
    );
  }

  void cancelAnswer(){
    GetIt.I<ChatActionBloc>().add(const TerminateStream());
  }
}