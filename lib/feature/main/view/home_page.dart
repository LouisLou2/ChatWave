import 'package:chat_wave/extension/widget_extension.dart';
import 'package:chat_wave/feature/chat/bloc/chating_action_bloc.dart';
import 'package:chat_wave/router/navigation_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../constant/assets_const.dart';
import '../../../domain/entity/chat_session.dart';
import '../../../style/app_colors.dart';
import '../../../ui/widget/backgroud_curves_painter.dart';
import '../../../ui/widget/card_button.dart';
import '../../chat/bloc/chat_history_bloc.dart';
import '../bloc/homepage_load_bloc.dart';
import '../widget/history_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    // 发出页面加载的动画
    GetIt.I<HomePageLoadBloc>().add(const StartLoadHomePage());
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: null,
      resizeToAvoidBottomInset: true,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 55, 8, 0),
            child: Column(
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: constraints.maxWidth/8,),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child:CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.2),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.settings,
                              size: 25,
                              color: context.theme.colorScheme.onSurface,
                            ),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How may I help\nyou today?',
                      style: context.theme.textTheme.headlineLarge!.copyWith(
                        letterSpacing: -0.3,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: CardButton(
                        title: 'Chat\nwith PDF',
                        color: AppColors.oilGreen,
                        foregroundColor: Colors.white,
                        imagePath: AssetsConst.pdfLogo,
                        isMainButton: true,
                        onPressed: () async {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          CardButton(
                            title: 'Chat with AI',
                            color: CupertinoColors.activeBlue,
                            foregroundColor: Colors.white,
                            imagePath: AssetsConst.textLogo,
                            isMainButton: false,
                            onPressed: _enterNewChat,
                          ),
                          const SizedBox(height: 8),
                          CardButton(
                            title: 'Image Studio',
                            color: AppColors.iconPink.shade300,
                            foregroundColor: Colors.white,
                            imagePath: AssetsConst.imageLogo,
                            isMainButton: false,
                            onPressed: () async {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(8, 25, 8, 0),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.95),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showAllHistory();
                        },
                        child: Text(
                          'See all',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HomePageLoadBloc, HomePageLoadState>(
                    buildWhen: (previous, current) {
                      // 如果前一个状态是success, 现在是loading，就不更新
                      return !(previous is HomePageLoadSuccess && current is HomePageLoadInProgress) && current is! HomePageLoadFailure;
                    },
                    builder: (context, state) {
                      if(state is ChatHistoryLoading){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }else if(state is HomePageLoadSuccess){
                        var recentChats = context.read<HomePageStateRep>().recentChats;
                        if(recentChats.isEmpty){
                          return _getEmptyHitorySign();
                        }
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: recentChats.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            return HistoryItem(
                              label: recentChats[index].title,
                              imagePath: AssetsConst.imageLogo,
                              color: context.theme.primaryColor,
                              onPressed: ()=>_enterChatPage(recentChats[index]),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEmptyHitorySign(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              'No chats yet',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width:10,),
            const Icon(CupertinoIcons.cube_box),
          ],
        ),
      ),
    );
  }

  void _showAllHistory(){
    showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      builder: (context)=>Column(
        children: [
          Container(
            height: 4,
            width: 50,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.only(top: 8, bottom: 16),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,),
              child:ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  return HistoryItem(
                    label: 'Hello',
                    imagePath: AssetsConst.imageLogo,
                    color: context.theme.primaryColor,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enterChatPage(ChatSession session){
    // 进入聊天页面
    GetIt.I<ChatHistoryBloc>().add(InitRetrieveHistory(session));
    GetIt.I<ChatActionBloc>().add(OpenExistSessionPage(session));
    NavigationHelper.goToChat();
  }

  void _enterNewChat(){
    GetIt.I<ChatHistoryBloc>().add(const OpenNewChatSession());
    GetIt.I<ChatActionBloc>().add(const OpenNewSessionPage());
    NavigationHelper.goToChat();
  }
}