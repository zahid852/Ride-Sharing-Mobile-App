import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../resources/routes_manager.dart';
import '../../../utils/utils.dart';
import '../../drawer/drawer_view_model.dart';

Widget passengerProfileData(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: getHeight(context: context) * 0.25 + 60,
              width: double.infinity,
              color: Colors.white,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: getHeight(context: context) * 0.25,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Container(
                  height: getHeight(context: context) * 0.25 - 58,
                  width: double.infinity,
                  color: Colors.lightGreen,
                ),
                Positioned(
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 58,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.imageRoute,
                              arguments:
                                  CommonData.passengerDataModal.profileImg);
                        },
                        child: CachedNetworkImage(
                          imageUrl: CommonData.passengerDataModal.profileImg,
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
                                  image: Image.asset(ImageAssets.profile).image,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                left: 15,
                top: 10,
                child: IconButton(
                    alignment: Alignment.topCenter,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ))),
            Positioned(
              top: 10,
              child: Text(
                'Profile',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: getWidth(context: context) * 0.7,
                    child: Center(
                      child: Text(
                        CommonData.passengerDataModal.name,
                        softWrap: true,
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: Scrollbar(
            thickness: 6.0,
            radius: const Radius.circular(8.0),
            isAlwaysShown: true,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 37),
                        child: Text(
                          'Email',
                          style: GoogleFonts.nunito(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getWidth(context: context) * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.email),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  CommonData.passengerDataModal.email,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 37),
                        child: Text(
                          'City',
                          style: GoogleFonts.nunito(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getWidth(context: context) * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.location_city),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                CommonData.passengerDataModal.city,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 37),
                        child: Row(
                          children: [
                            Text(
                              'Phone',
                              style: GoogleFonts.nunito(
                                  color: Colors.lightGreen,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getWidth(context: context) * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.call),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                CommonData.passengerDataModal.phone,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 37),
                        child: Text(
                          'Gender',
                          style: GoogleFonts.nunito(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getWidth(context: context) * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(MdiIcons.faceManProfile),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                CommonData.passengerDataModal.gender,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 37),
                        child: Text(
                          'User role',
                          style: GoogleFonts.nunito(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getWidth(context: context) * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(IconlyBold.profile),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Passenger',
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ])));
}
