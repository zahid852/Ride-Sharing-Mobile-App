import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/data_source/local_data_source.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';
import '../../utils/utils.dart';
import '../../utils/widgets.dart';

class NotificationScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  const NotificationScreen({Key? key, required this.menuButtonFunction})
      : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  late Future<List<NotificationModel>> _getNotificationsData;
  @override
  void initState() {
    _getNotificationsData = _localDataSource.readNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Container(
          height: getHeight(context: context) * 0.07,
          color: Colors.lightGreen,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: getWidth(context: context),
              ),
              Positioned(
                  left: 15,
                  child: IconButton(
                      onPressed: widget.menuButtonFunction,
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ))),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 40),
                child: Text(
                  'Notifications',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
              // Positioned(
              //     right: 15,
              //     child: IconButton(
              //         onPressed: () {
              //           _localDataSource.deleteLocalDatabase();
              //         },
              //         icon: const Icon(
              //           Icons.close,
              //           color: Colors.white,
              //           size: 28,
              //         ))),
            ],
          ),
        ),
        Expanded(
            child: FutureBuilder<List<NotificationModel>>(
                future: _getNotificationsData,
                builder: (futureCtx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return getLoadingWidget(context);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: getHeight(context: context) * 0.07),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
                                  'Something went wrong. Please try again later.',
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
                                              horizontal: 10, vertical: 2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4))),
                                      onPressed: () {
                                        setState(() {
                                          _getNotificationsData =
                                              _localDataSource
                                                  .readNotifications();
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
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: getHeight(context: context) * 0.07),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 16),
                              width: getWidth(context: context) * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Lottie.asset(
                                      LottieAssets.empty,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'You have not received any notifications yet.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      List<dynamic> notificationModelList =
                          snapshot.data as List<dynamic>;
                      return ListView.builder(
                          itemCount: notificationModelList.length,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (ctx, index) {
                            NotificationModel notification =
                                notificationModelList[index];
                            return Column(
                              children: [
                                ListTile(
                                  titleAlignment: ListTileTitleAlignment.top,
                                  leading: CircleAvatar(
                                    radius: 24.5,
                                    backgroundColor: Colors.lightGreen,
                                    child: CircleAvatar(
                                      radius: 24,
                                      child: CachedNetworkImage(
                                        imageUrl: notification.userImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        errorWidget: (_, url, error) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: Image.asset(
                                                        ImageAssets.profile)
                                                    .image,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  title: Text(
                                    notification.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.body,
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        notification.dateTime,
                                        style: GoogleFonts.nunito(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                notificationModelList.length - 1 == index
                                    ? const SizedBox.shrink()
                                    : const Column(
                                        children: [
                                          Divider(
                                            height: 0,
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      )
                              ],
                            );
                          });
                    }
                  }
                })),
      ],
    )));
  }
}
