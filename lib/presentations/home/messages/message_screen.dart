import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/messages/messages_view_model.dart';
import 'package:lift_app/presentations/splash/splash_screen.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/mapper/mappers.dart';
import '../../../data/network/failure.dart';
import '../../resources/assets_manager.dart';
import '../../utils/notifications_service.dart';
import '../../utils/socket.dart';

class MessageScreen extends StatefulWidget {
  final String opponentName;
  final String opponentImage;
  final ChatObjectModel chatObjectModel;
  const MessageScreen({
    Key? key,
    required this.opponentName,
    required this.opponentImage,
    required this.chatObjectModel,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageEditingController =
      TextEditingController();
  late Future<void> getData;
  bool getInitialData = false;
  final _scrollController = ScrollController();
  bool isSendingMessage = false;
  bool isError = false;
  String errorMessage = EMPTY;
  void listenMessages() {
    SocketImplementation.socket.on('message received', (data) {
      if (mounted) {
        getData = Provider.of<MessagesViewModel>(context, listen: false)
            .getMessages(GetMessagesRequest(widget.chatObjectModel.roomId));
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    listenMessages();
    getData = Provider.of<MessagesViewModel>(context, listen: false)
        .getMessages(GetMessagesRequest(widget.chatObjectModel.roomId));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageEditingController.dispose();

    super.dispose();
  }

  void scrollToBottom() {
    Timer(const Duration(milliseconds: 0), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              shadowColor: Colors.black87,
              toolbarHeight: 65,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
              titleSpacing: 5,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.4,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 20,
                          child: CachedNetworkImage(
                            imageUrl: widget.opponentImage,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            errorWidget: (_, url, error) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        Image.asset(ImageAssets.profile).image,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.opponentName,
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call,
                          color: Colors.lightGreen,
                        )),
                  )
                ],
              ),
            ),
            body: SizedBox(
              height: getHeight(context: context),
              width: getWidth(context: context),
              child: isError
                  ? Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                          width: getWidth(context: context) * 0.75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 1.5),
                                    blurRadius: 0.4,
                                    spreadRadius: 0.2),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Lottie.asset(
                                  LottieAssets.failure,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    onPressed: () {
                                      setState(() {
                                        isError = false;
                                        getData = Provider.of<
                                                    MessagesViewModel>(context,
                                                listen: false)
                                            .getMessages(GetMessagesRequest(
                                                widget.chatObjectModel.roomId));
                                        errorMessage = EMPTY;
                                        isSendingMessage = false;
                                      });
                                    },
                                    child: Text(
                                      'Reload',
                                      style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : FutureBuilder(
                      future: getData,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !getInitialData) {
                          return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Align(
                                    alignment: index % 2 == 0
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: SizedBox(
                                      width: getWidth(context: context) * 0.6,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Shimmer.fromColors(
                                            baseColor: Utils(context: context)
                                                .baseShimmerColor,
                                            highlightColor:
                                                Utils(context: context)
                                                    .highlightShimmerColor,
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Utils(context: context)
                                                    .widgetShimmerColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: getHeight(context: context) * 0.07),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 12),
                                  width: getWidth(context: context) * 0.7,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Lottie.asset(
                                          LottieAssets.failure,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        snapshot.error.runtimeType == Failure
                                            ? (snapshot.error as Failure)
                                                .message
                                            : 'Something went wrong. Please try again later.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4))),
                                            onPressed: () {
                                              setState(() {
                                                getData = Provider.of<
                                                            MessagesViewModel>(
                                                        context,
                                                        listen: false)
                                                    .getMessages(
                                                        GetMessagesRequest(
                                                            widget
                                                                .chatObjectModel
                                                                .roomId));
                                              });
                                            },
                                            child: Text(
                                              'Reload',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Consumer<MessagesViewModel>(
                              builder: (cunCtx, viewModel, _) {
                            getInitialData = true;
                            scrollToBottom();
                            return Column(
                              children: [
                                isSendingMessage
                                    ? SizedBox(
                                        child: LinearProgressIndicator(
                                          color: Colors.lightGreen[500],
                                          backgroundColor:
                                              Colors.lightGreen[100],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Expanded(
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      itemCount: viewModel.messagesList.length,
                                      itemBuilder: (buildCtx, index) {
                                        final MessageObjectModel message =
                                            viewModel.messagesList[index];

                                        return Align(
                                          alignment: message.senderId ==
                                                  CommonData
                                                      .passengerDataModal.id
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  getWidth(context: context) *
                                                      0.7,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                  bottomLeft:
                                                      const Radius.circular(15),
                                                  bottomRight:
                                                      const Radius.circular(15),
                                                  topLeft: Radius.circular(message
                                                              .senderId !=
                                                          CommonData
                                                              .passengerDataModal
                                                              .id
                                                      ? 0
                                                      : 15),
                                                  topRight: Radius.circular(message
                                                              .senderId !=
                                                          CommonData
                                                              .passengerDataModal
                                                              .id
                                                      ? 15
                                                      : 0),
                                                )),
                                                color: message.senderId !=
                                                        CommonData
                                                            .passengerDataModal
                                                            .id
                                                    ? Colors.white
                                                    : Colors.lightGreen[100],
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                                  child: Column(
                                                    crossAxisAlignment: message
                                                                .senderId !=
                                                            CommonData
                                                                .passengerDataModal
                                                                .id
                                                        ? CrossAxisAlignment
                                                            .start
                                                        : CrossAxisAlignment
                                                            .end,
                                                    children: [
                                                      Text(
                                                        message.content,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      // const SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      // Text(
                                                      //   '',
                                                      //   style: GoogleFonts.nunito(
                                                      //       fontSize: 13,
                                                      //       color: Colors.grey,
                                                      //       fontWeight:
                                                      //           FontWeight.w500),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: getWidth(context: context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _messageEditingController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 15),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 3),
                                                child: Icon(
                                                  Icons.message,
                                                  size: 25,
                                                ),
                                              ),
                                              label: Text(
                                                'Message',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              if (_messageEditingController
                                                  .text.isNotEmpty) {
                                                try {
                                                  setState(() {
                                                    isSendingMessage = true;
                                                    isError = false;
                                                    errorMessage = EMPTY;
                                                  });
                                                  log('room id ${widget.chatObjectModel.roomId}');
                                                  log('user 0 ${widget.chatObjectModel.usersList[0]}');
                                                  log('user 1 ${widget.chatObjectModel.usersList[1]}');

                                                  await viewModel.sendMessage(
                                                      SendMessageRequest(
                                                          widget.chatObjectModel
                                                              .roomId,
                                                          _messageEditingController
                                                              .text));
                                                  //Notification part
                                                  NotificationsService.sendPushNotification(
                                                      SendNotificationRequest(
                                                          [
                                                            widget.chatObjectModel
                                                                            .usersList[
                                                                        0] ==
                                                                    CommonData
                                                                        .passengerDataModal
                                                                        .id
                                                                ? widget.chatObjectModel
                                                                        .usersList[
                                                                    1]
                                                                : widget
                                                                    .chatObjectModel
                                                                    .usersList[0]
                                                          ],
                                                          CommonData
                                                              .passengerDataModal
                                                              .name,
                                                          _messageEditingController
                                                              .text,
                                                          <String, dynamic>{
                                                            'type': 'Message',
                                                            'model': widget
                                                                .chatObjectModel
                                                                .toJson(),
                                                            'title': CommonData
                                                                .passengerDataModal
                                                                .name,
                                                            'body':
                                                                _messageEditingController
                                                                    .text,
                                                            'userImage': CommonData
                                                                .passengerDataModal
                                                                .profileImg,
                                                            'userId': [
                                                              widget.chatObjectModel
                                                                              .usersList[
                                                                          0] ==
                                                                      CommonData
                                                                          .passengerDataModal
                                                                          .id
                                                                  ? widget.chatObjectModel
                                                                          .usersList[
                                                                      1]
                                                                  : widget
                                                                      .chatObjectModel
                                                                      .usersList[0]
                                                            ],
                                                          },
                                                          globalAppPreferences
                                                              .getFCMToken()));
                                                  setState(() {
                                                    isSendingMessage = false;
                                                    isError = false;
                                                    errorMessage = EMPTY;
                                                  });
                                                  _messageEditingController
                                                      .clear();
                                                } on Failure catch (e) {
                                                  setState(() {
                                                    isSendingMessage = false;
                                                    isError = true;
                                                    errorMessage = e.message;
                                                    getInitialData = false;
                                                  });
                                                } catch (e) {
                                                  setState(() {
                                                    isSendingMessage = false;
                                                    getInitialData = false;
                                                    isError = true;
                                                    errorMessage =
                                                        'Something went wrong. Please try again.';
                                                  });
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.send,
                                              color: Colors.lightGreen,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          });
                        }
                      },
                    ),
            )),
      ),
    );
  }
}
