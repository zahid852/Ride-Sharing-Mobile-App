import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/data_source/local_data_source.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/license_info/license_info_viewmodel.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class LicenseInfoScreen extends StatefulWidget {
  const LicenseInfoScreen({Key? key}) : super(key: key);

  @override
  State<LicenseInfoScreen> createState() => _LicenseInfoScreenState();
}

class _LicenseInfoScreenState extends State<LicenseInfoScreen> {
  final TextEditingController _numberEditingController =
      TextEditingController();
  final TextEditingController _expiryDateEditingController =
      TextEditingController();
  File? _licenseCertificate;
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  LicenseInfoModel? _licenseInfoModel;
  late Future getData;
  final LicenseInfoViewModel _licenseInfoViewModel = LicenseInfoViewModel();
  bool _isLicenseInfoButtonValidInitially = false;
  final _formKey = GlobalKey<FormState>();
  bool? _isImageEmptyOnValidation;
  bool? _isExpiryDateEmptyOnValidation;
  _bind() {
    _numberEditingController.addListener(
        () => _licenseInfoViewModel.setNumber(_numberEditingController.text));
    _expiryDateEditingController.addListener(() =>
        _licenseInfoViewModel.setExpiryDate(_expiryDateEditingController.text));
  }

  @override
  void initState() {
    _bind();
    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    _licenseInfoModel = await _localDataSource
        .read(LocalDataSourceConstants.licenseInfoTable) as LicenseInfoModel?;

    if (_licenseInfoModel != null) {
      _numberEditingController.text = _licenseInfoModel?.number ?? EMPTY;
      _expiryDateEditingController.text =
          _licenseInfoModel?.expiryDate ?? EMPTY;
      final tempDir = await getApplicationDocumentsDirectory();
      _licenseCertificate =
          await File('${tempDir.path}/licenseCertificate.png').create();
      _licenseCertificate!.writeAsBytesSync(ImagesUtility.dataFromBase64String(
          _licenseInfoModel?.licenseCertificate ?? EMPTY));
      _isLicenseInfoButtonValidInitially = true;
    }
  }

  @override
  void dispose() {
    _numberEditingController.dispose();
    _expiryDateEditingController.dispose();
    _licenseInfoViewModel.dispose();
    super.dispose();
  }

  void _getPhotoFromCamera() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      _licenseCertificate = File(pickedFile.path);
      _licenseCertificate = await cropImage(imageFile: _licenseCertificate!);
      setState(() {});
    }
  }

  void _getPhotoFromGallery() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      _licenseCertificate = File(pickedFile.path);
      _licenseCertificate = await cropImage(imageFile: _licenseCertificate!);
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
                    child: Column(children: [
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
                            'License Info',
                            style: GoogleFonts.nunito(
                                fontSize: 24,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 10),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Form(
                                              key: _formKey,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 14),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _numberEditingController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.numbers_sharp,
                                                          size: 25,
                                                        ),
                                                        label: Text('NUMBER'),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Enter number';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _expiryDateEditingController,
                                                      readOnly: true,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon:
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 3),
                                                          child: Icon(
                                                            Icons.date_range,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                            .grey[
                                                                        300]!)),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: _isExpiryDateEmptyOnValidation ==
                                                                    true
                                                                ? Colors.red
                                                                : Colors
                                                                    .lightGreen,
                                                          ),
                                                          iconSize: 30,
                                                          onPressed: () async {
                                                            final DateTime? date = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: _licenseInfoModel !=
                                                                        null
                                                                    ? DateFormat(
                                                                            "dd/MM/yyyy")
                                                                        .parse(_licenseInfoModel!
                                                                            .expiryDate)
                                                                    : DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100));
                                                            if (date != null) {
                                                              _expiryDateEditingController
                                                                      .text =
                                                                  DateFormat(
                                                                          'dd/MM/yyyy')
                                                                      .format(
                                                                          date);
                                                            }
                                                          },
                                                        ),
                                                        label: const Text(
                                                            'EXPIRY DATE'),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          setState(() {
                                                            _isExpiryDateEmptyOnValidation =
                                                                true;
                                                          });
                                                          return 'Enter expiry date';
                                                        }
                                                        setState(() {
                                                          _isExpiryDateEmptyOnValidation =
                                                              false;
                                                        });
                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 10),
                                          child: Card(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  'License Certificate',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.lightGreen,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _licenseCertificate == null
                                                    ? Container(
                                                        height: getHeight(
                                                                context:
                                                                    context) *
                                                            0.25,
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
                                                            0.8,
                                                      )
                                                    : AspectRatio(
                                                        aspectRatio: 5 / 4,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[400],
                                                              image: DecorationImage(
                                                                  image: FileImage(
                                                                      _licenseCertificate!))),
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
                                                          addPhotoDialog();
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
                                                _isImageEmptyOnValidation ==
                                                        true
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                Icons.image,
                                                                color:
                                                                    Colors.red,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                'Add image',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox.shrink(),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          height: 55,
                                          width:
                                              getWidth(context: context) * 0.6,
                                          child: StreamBuilder(
                                              initialData:
                                                  _isLicenseInfoButtonValidInitially,
                                              stream: _licenseInfoViewModel
                                                  .outputIsAllInputValid,
                                              builder: (context, snapshot) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (snapshot.data ==
                                                        false) {
                                                      _formKey.currentState!
                                                          .validate();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    }
                                                    if (_licenseCertificate ==
                                                        null) {
                                                      _formKey.currentState!
                                                          .validate();
                                                      setState(() {
                                                        _isImageEmptyOnValidation =
                                                            true;
                                                      });
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    }
                                                    if (_licenseCertificate !=
                                                            null &&
                                                        _isImageEmptyOnValidation ==
                                                            true) {
                                                      setState(() {
                                                        _isImageEmptyOnValidation =
                                                            false;
                                                      });
                                                    }
                                                  },
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                      onPressed: (snapshot
                                                                      .data ==
                                                                  false ||
                                                              _licenseCertificate ==
                                                                  null)
                                                          ? null
                                                          : () async {
                                                              _isImageEmptyOnValidation ==
                                                                      true
                                                                  ? setState(
                                                                      () {
                                                                      _isImageEmptyOnValidation =
                                                                          false;
                                                                    })
                                                                  : null;
                                                              _formKey
                                                                  .currentState!
                                                                  .validate();
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              _localDataSource
                                                                  .insert(
                                                                      LocalDataSourceConstants
                                                                          .licenseInfoTable,
                                                                      LicenseInfoModel(
                                                                        _appPreferences
                                                                            .getUserId(),
                                                                        _numberEditingController
                                                                            .text,
                                                                        _expiryDateEditingController
                                                                            .text,
                                                                        ImagesUtility.base64String(
                                                                            await _licenseCertificate!.readAsBytes()),
                                                                      ));
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                      child: Text(
                                                        'Done',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      )),
                                                );
                                              }),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ])))),
      ),
    );
  }

  void addPhotoDialog() {
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
                  onTap: _getPhotoFromCamera,
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
                  onTap: _getPhotoFromGallery,
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
