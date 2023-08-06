import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/di.dart';
import '../../../../data/data_source/local_data_source.dart';
import '../../../../data/mapper/mappers.dart';
import '../../../resources/assets_manager.dart';

class VehicleImagesScreen extends StatefulWidget {
  const VehicleImagesScreen({Key? key}) : super(key: key);

  @override
  State<VehicleImagesScreen> createState() => _VehicleImagesScreenState();
}

class _VehicleImagesScreenState extends State<VehicleImagesScreen> {
  File? _vehicleImage;
  File? _vehicleCertificateImage;
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  VehicleImagesModel? _vehicleImagesModel;
  final _fToast = FToast();
  late Future getData;

  @override
  void initState() {
    _fToast.init(context);
    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    _vehicleImagesModel =
        await _localDataSource.read(LocalDataSourceConstants.vehicleImagesTable)
            as VehicleImagesModel?;
    if (_vehicleImagesModel != null) {
      /*
      We are receiving base64 string from backend, first we will have to convert it to Uint8List 
      data type(decoding) then convert it to file.
      */
      final tempDir = await getApplicationDocumentsDirectory();
      _vehicleImage = await File('${tempDir.path}/vehicle.png').create();
      _vehicleImage!.writeAsBytesSync(ImagesUtility.dataFromBase64String(
          _vehicleImagesModel?.vehicle ?? EMPTY));

      _vehicleCertificateImage =
          await File('${tempDir.path}/vehicleRegistrationCertificate.png')
              .create();
      _vehicleCertificateImage!.writeAsBytesSync(
          ImagesUtility.dataFromBase64String(
              _vehicleImagesModel?.vehicleRegistrationCertificate ?? EMPTY));
    }
  }

  void _getPhotoFromCamera({required String side}) async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      if (side == 'VehicleImage') {
        _vehicleImage = File(pickedFile.path);
        _vehicleImage = await cropImage(imageFile: _vehicleImage!);
      } else {
        _vehicleCertificateImage = File(pickedFile.path);
        _vehicleCertificateImage =
            await cropImage(imageFile: _vehicleCertificateImage!);
      }
      setState(() {});
    }
  }

  void _getPhotoFromGallery({required String side}) async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      if (side == 'VehicleImage') {
        _vehicleImage = File(pickedFile.path);
        _vehicleImage = await cropImage(imageFile: _vehicleImage!);
      } else {
        _vehicleCertificateImage = File(pickedFile.path);
        _vehicleCertificateImage =
            await cropImage(imageFile: _vehicleCertificateImage!);
      }
      setState(() {});
    }
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
          body: SafeArea(
              child: SizedBox(
            height: getHeight(context: context),
            width: getWidth(context: context),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: getWidth(context: context),
                    ),
                    Positioned(
                        left: 15,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios))),
                    Text(
                      'Vehicle Images',
                      style: GoogleFonts.nunito(
                          fontSize: 22,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: getData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: getHeight(context: context) -
                                        getHeight(context: context) * 0.2,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ));
                              }
                              return Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 5,
                                          top: 0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: SizedBox(
                                          width: getWidth(context: context),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'Vehicle',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.lightGreen,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                _vehicleImage == null
                                                    ? Container(
                                                        height: getHeight(
                                                                context:
                                                                    context) *
                                                            0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: Image.asset(
                                                                      ImageAssets
                                                                          .vehicle)
                                                                  .image),
                                                        ),
                                                        width: getWidth(
                                                                context:
                                                                    context) *
                                                            0.7,
                                                      )
                                                    : AspectRatio(
                                                        aspectRatio: 5 / 4,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              image: DecorationImage(
                                                                  image: FileImage(
                                                                      _vehicleImage!))),
                                                        )),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                SizedBox(
                                                    height: 40,
                                                    width: getWidth(
                                                            context: context) *
                                                        0.3,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            foregroundColor:
                                                                Colors
                                                                    .lightGreen,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .lightGreen))),
                                                        onPressed: () {
                                                          addPhotoDialog(
                                                              side:
                                                                  'VehicleImage');
                                                        },
                                                        child: Text(
                                                          'Add Photo',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        )))
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 20),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: SizedBox(
                                          width: getWidth(context: context),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'Vehicle Registration Certificate',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.lightGreen,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                _vehicleCertificateImage == null
                                                    ? Container(
                                                        height: getHeight(
                                                                context:
                                                                    context) *
                                                            0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: Image.asset(
                                                                      ImageAssets
                                                                          .vehicleCertificate)
                                                                  .image),
                                                        ),
                                                        width: getWidth(
                                                                context:
                                                                    context) *
                                                            0.7,
                                                      )
                                                    : AspectRatio(
                                                        aspectRatio: 5 / 4,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              image: DecorationImage(
                                                                  image: FileImage(
                                                                      _vehicleCertificateImage!))),
                                                        )),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                SizedBox(
                                                    height: 40,
                                                    width: getWidth(
                                                            context: context) *
                                                        0.3,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          addPhotoDialog(
                                                              side:
                                                                  'VehicleCertificate');
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            foregroundColor:
                                                                Colors
                                                                    .lightGreen,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                side: const BorderSide(
                                                                    color: Colors
                                                                        .lightGreen))),
                                                        child: Text(
                                                          'Add Photo',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                      height: 45,
                                      width: getWidth(context: context) * 0.5,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_vehicleImage == null ||
                                              _vehicleCertificateImage ==
                                                  null) {
                                            _fToast.showToast(
                                                child: buildToast(
                                                    type: ToastMessageType
                                                        .failure,
                                                    mes:
                                                        'Please add both vehicle photos to submit the information'));
                                          }
                                        },
                                        child: ElevatedButton(
                                            onPressed: (_vehicleImage == null ||
                                                    _vehicleCertificateImage ==
                                                        null)
                                                ? null
                                                : () async {
                                                    _localDataSource.insert(
                                                        LocalDataSourceConstants
                                                            .vehicleImagesTable,
                                                        VehicleImagesModel(
                                                          _appPreferences
                                                              .getUserId(),
                                                          /*
                                                            We have image in file format, first we will have to convert it to Uint8List data type
                                                            then convert it to base64 String(encoding).
                                                            */
                                                          ImagesUtility.base64String(
                                                              await _vehicleImage!
                                                                  .readAsBytes()),
                                                          ImagesUtility.base64String(
                                                              await _vehicleCertificateImage!
                                                                  .readAsBytes()),
                                                        ));

                                                    if (!mounted) return;
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                            child: Text(
                                              'Done',
                                              style: GoogleFonts.nunito(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )),
                                      )),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void addPhotoDialog({required String side}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 35, top: 25, bottom: 10),
                  child: Text(
                    'Choose option',
                    style: GoogleFonts.nunito(
                        fontSize: 20,
                        color: Colors.lightGreen[400],
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                )
              ],
            ),
            contentPadding: const EdgeInsets.only(
              top: 10,
              bottom: 15,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => _getPhotoFromCamera(side: side),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.camera,
                    ),
                  ),
                  minLeadingWidth: 25,
                  title: Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: Text(
                      'Take a picture',
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => _getPhotoFromGallery(side: side),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.photo),
                  ),
                  minLeadingWidth: 28,
                  title: Padding(
                    padding: const EdgeInsets.only(right: 70),
                    child: Text(
                      'Photo from gallery',
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Close',
                  ))
            ],
          );
        });
  }
}
