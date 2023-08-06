import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/presentations/home/settings/components/profile_view_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../domain/model/models.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets.dart';
import '../../drawer/drawer_view_model.dart';

class DriverProfilePart extends StatelessWidget {
  final DriverDetailsModel driverDetailsModel;
  final ShowProfileViewModel showProfileViewModel;
  const DriverProfilePart(
      {Key? key,
      required this.driverDetailsModel,
      required this.showProfileViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('vehicle image ${driverDetailsModel.vehicleImage}');
    log('vehicle image ${CommonData.passengerDataModal.profileImg}');
    log('vehicle image ${driverDetailsModel.cnicImgFront}');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: getHeight(context: context) * 0.54,
            pinned: true,
            elevation: 2,
            toolbarHeight: 62,
            backgroundColor: Colors.lightGreen,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 2.5),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )),
            stretch: false,
            title: InvisibleExpandedHeader(
                child: Text(
              'Profile',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            )),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            height: getHeight(context: context) * 0.4,
                            width: getWidth(context: context),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.imageRoute,
                                  arguments: driverDetailsModel.vehicleImage);
                            },
                            child: CachedNetworkImage(
                              imageUrl: driverDetailsModel.vehicleImage,
                              height: getHeight(context: context) * 0.335,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              errorWidget: (_, url, error) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        Image.asset(ImageAssets.carPaceholder)
                                            .image,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Routes.imageRoute,
                                      arguments: CommonData
                                          .passengerDataModal.profileImg);
                                },
                                child: CircleAvatar(
                                  radius: 59,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 55,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(65),
                                      child: CachedNetworkImage(
                                        imageUrl: CommonData
                                            .passengerDataModal.profileImg,
                                        fit: BoxFit.cover,
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
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.asset(
                                                      ImageAssets.profile)
                                                  .image,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: getWidth(context: context) * 0.7,
                        child: Center(
                          child: Text(
                            CommonData.passengerDataModal.name,
                            softWrap: true,
                            style: GoogleFonts.nunito(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RatingBar.builder(
                          initialRating:
                              driverDetailsModel.totalReviewsGiven == 0
                                  ? 5
                                  : (driverDetailsModel.totalRating /
                                      driverDetailsModel.totalReviewsGiven),
                          itemSize: 25,
                          allowHalfRating: true,
                          unratedColor: Colors.black54,
                          ignoreGestures: true,
                          itemBuilder: (ctx, _) {
                            return const DecoratedIcon(
                              icon:
                                  Icon(Icons.star, color: Colors.yellowAccent),
                              decoration: IconDecoration(
                                border: IconBorder(width: 1.5),
                              ),
                            );
                          },
                          onRatingUpdate: (_) {}),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            driverDetailsModel.totalReviewsGiven == 0
                                ? '5'
                                : (driverDetailsModel.totalRating /
                                        driverDetailsModel.totalReviewsGiven)
                                    .toStringAsFixed(2),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '(${driverDetailsModel.totalReviewsGiven})',
                            style: GoogleFonts.nunito(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 37),
                      child: Text(
                        'Father Name',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Icon(IconlyBold.profile),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                driverDetailsModel.fatherName,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                        'Birth Date',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Icon(IconlyBold.calendar),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                driverDetailsModel.birthDate,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
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
                        'CNIC',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Icon(MdiIcons.cardAccountDetails),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                driverDetailsModel.cnic,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 37),
                      child: Text(
                        'Images',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getWidth(context: context) * 0.85 / 2 - 2.5,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 5 / 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.imageRoute,
                                        arguments:
                                            driverDetailsModel.cnicImgFront);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: driverDetailsModel.cnicImgFront,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image:
                                              Image.asset(ImageAssets.cnicFront)
                                                  .image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'CNIC-Front',
                                style: GoogleFonts.nunito(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: getWidth(context: context) * 0.85 / 2 - 2.5,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 5 / 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.imageRoute,
                                        arguments:
                                            driverDetailsModel.cnicImgBack);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: driverDetailsModel.cnicImgBack,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image:
                                              Image.asset(ImageAssets.cnicBack)
                                                  .image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'CNIC-Back',
                                style: GoogleFonts.nunito(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 37),
                      child: Text(
                        'Residential Address',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Icon(IconlyBold.location),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                driverDetailsModel.residentialAddress,
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: getWidth(context: context) * 0.85,
                          child: showProfileViewModel.showVehicleDetails ==
                                  false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      showProfileViewModel
                                          .customizeVehicleDetailsBox(
                                              showProfileViewModel
                                                  .showVehicleDetails);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[300]!)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 0),
                                                    child: Icon(
                                                        IconlyBold.document),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Vehicle Details',
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: () {
                                                showProfileViewModel
                                                    .customizeVehicleDetailsBox(
                                                        showProfileViewModel
                                                            .showVehicleDetails);
                                              },
                                              icon: SvgPicture.asset(
                                                ImageAssets.arrowDownIcon,
                                                alignment:
                                                    Alignment.centerRight,
                                                height: 18,
                                                color: Colors.lightGreen,
                                                width: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showProfileViewModel
                                              .customizeVehicleDetailsBox(
                                                  showProfileViewModel
                                                      .showVehicleDetails);
                                        },
                                        icon: SvgPicture.asset(
                                          ImageAssets.arrowUpIcon,
                                          color: Colors.lightGreen,
                                          height: 20,
                                          width: 20,
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Colors.lightGreen.withOpacity(0.25),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Icon(
                                                    MdiIcons.car,
                                                    color:
                                                        Colors.lightGreen[700],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Vehicle Type',
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 16,
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        driverDetailsModel
                                                            .vehicleType,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                              // height: 8,
                                              ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Icon(
                                                    IconlyBold.bookmark,
                                                    color:
                                                        Colors.lightGreen[700],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Vehicle Brand',
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 16,
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        driverDetailsModel
                                                            .vehicleBrand,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                              // height: 8,
                                              ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Icon(
                                                    Icons.numbers,
                                                    color:
                                                        Colors.lightGreen[700],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Vehicle Number',
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 16,
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        driverDetailsModel
                                                            .vehicleNumber,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: getWidth(context: context) * 0.85,
                          child: showProfileViewModel.showLiscenseDetails ==
                                  false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: () {
                                      showProfileViewModel
                                          .customizeLiscenseDetailsBox(
                                              showProfileViewModel
                                                  .showLiscenseDetails);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[300]!)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 1),
                                                    child: Icon(
                                                        IconlyBold.document),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    'Liscense Details',
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: () {
                                                showProfileViewModel
                                                    .customizeLiscenseDetailsBox(
                                                        showProfileViewModel
                                                            .showLiscenseDetails);
                                              },
                                              icon: SvgPicture.asset(
                                                ImageAssets.arrowDownIcon,
                                                alignment:
                                                    Alignment.centerRight,
                                                height: 18,
                                                color: Colors.lightGreen,
                                                width: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showProfileViewModel
                                              .customizeLiscenseDetailsBox(
                                                  showProfileViewModel
                                                      .showLiscenseDetails);
                                        },
                                        icon: SvgPicture.asset(
                                          ImageAssets.arrowUpIcon,
                                          color: Colors.lightGreen,
                                          height: 20,
                                          width: 20,
                                        )),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            Colors.lightGreen.withOpacity(0.25),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Icon(
                                                    Icons.numbers,
                                                    color:
                                                        Colors.lightGreen[700],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Liscense Number',
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 16,
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        driverDetailsModel
                                                            .liscenseNumber,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                              // height: 8,
                                              ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Icon(
                                                    IconlyBold.bookmark,
                                                    color:
                                                        Colors.lightGreen[700],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Liscense Expiry Date',
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 16,
                                                            color: Colors
                                                                    .lightGreen[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        driverDetailsModel
                                                            .liscenseExpiryDate,
                                                        softWrap: true,
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 37),
                      child: Text(
                        'Vehicle & Liscense',
                        style: GoogleFonts.nunito(
                            color: Colors.lightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getWidth(context: context) * 0.85 / 2 - 2.5,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 5 / 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.imageRoute,
                                        arguments: driverDetailsModel
                                            .vehicleRegisterCertificate);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: driverDetailsModel
                                        .vehicleRegisterCertificate,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: Image.asset(ImageAssets
                                                  .vehicleCertificate)
                                              .image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Vehicle Certificate',
                                style: GoogleFonts.nunito(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: getWidth(context: context) * 0.85 / 2 - 2.5,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 5 / 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Routes.imageRoute,
                                        arguments:
                                            driverDetailsModel.liscenseImage);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: driverDetailsModel.liscenseImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: Image.asset(ImageAssets
                                                  .vehicleCertificate)
                                              .image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Liscense',
                                style: GoogleFonts.nunito(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
