import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/driver/driver_viewmodel.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../app/services.dart';
import '../../data/data_source/local_data_source.dart';
import '../../data/network/failure.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({Key? key}) : super(key: key);

  @override
  State<DriverProfileScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverProfileScreen> {
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final DriverViewModel _driverViewModel = DriverViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final FToast _fToast = FToast();
  bool isBasicInfoDone = false;
  bool isCNICImagesDone = false;
  bool isVehicleInfoDone = false;
  bool isVehicleImagesDone = false;
  bool isLicenseInfoDone = false;
  late Future getData;
  bool _isLoading = false;
  @override
  void initState() {
    _fToast.init(context);
    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    final basicInfoTable =
        await _localDataSource.read(LocalDataSourceConstants.basicInfoTable);
    final cnicImagesTable =
        await _localDataSource.read(LocalDataSourceConstants.cnicImagesTable);
    final vehicleInfoTable =
        await _localDataSource.read(LocalDataSourceConstants.vehicleInfoTable);
    final vehicleImagesTable = await _localDataSource
        .read(LocalDataSourceConstants.vehicleImagesTable);
    final licenseInfoTable =
        await _localDataSource.read(LocalDataSourceConstants.licenseInfoTable);
    isBasicInfoDone = basicInfoTable != null ? true : false;
    isCNICImagesDone = cnicImagesTable != null ? true : false;
    isVehicleInfoDone = vehicleInfoTable != null ? true : false;
    isVehicleImagesDone = vehicleImagesTable != null ? true : false;
    isLicenseInfoDone = licenseInfoTable != null ? true : false;
  }

  Widget getIcon() {
    return const Icon(
      Icons.arrow_forward_ios,
      size: 20,
    );
  }

  void _createDriverAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final BasicInfoModel basicInfoTable = await _localDataSource
          .read(LocalDataSourceConstants.basicInfoTable) as BasicInfoModel;
      final CNICImagesModel cnicImagesTable = await _localDataSource
          .read(LocalDataSourceConstants.cnicImagesTable) as CNICImagesModel;
      final VehicleInfoModel vehicleInfoTable = await _localDataSource
          .read(LocalDataSourceConstants.vehicleInfoTable) as VehicleInfoModel;
      final VehicleImagesModel vehicleImagesTable = await _localDataSource.read(
          LocalDataSourceConstants.vehicleImagesTable) as VehicleImagesModel;
      final LicenseInfoModel licenseInfoTable = await _localDataSource
          .read(LocalDataSourceConstants.licenseInfoTable) as LicenseInfoModel;
      // cnic images
      final tempDir = await getApplicationDocumentsDirectory();
      final File cnicFrontImage =
          await File('${tempDir.path}/cnicFront.png').create();
      cnicFrontImage.writeAsBytesSync(
          ImagesUtility.dataFromBase64String(cnicImagesTable.cnicFront));

      final File cnicBackImage =
          await File('${tempDir.path}/cnicBack.png').create();
      cnicBackImage.writeAsBytesSync(
          ImagesUtility.dataFromBase64String(cnicImagesTable.cnicBack));

      // vehicle images
      final File vehicleImage =
          await File('${tempDir.path}/vehicle.png').create();
      vehicleImage.writeAsBytesSync(
          ImagesUtility.dataFromBase64String(vehicleImagesTable.vehicle));

      final File vehicleCertificateImage =
          await File('${tempDir.path}/vehicleCertificate.png').create();
      vehicleCertificateImage.writeAsBytesSync(
          ImagesUtility.dataFromBase64String(
              vehicleImagesTable.vehicleRegistrationCertificate));

      //license Image
      final File licenseImage =
          await File('${tempDir.path}/licenseImage.png').create();
      licenseImage.writeAsBytesSync(ImagesUtility.dataFromBase64String(
          licenseInfoTable.licenseCertificate));

      await _driverViewModel.registerDriver(RegisterDriverRequest(
          basicInfoTable.id,
          basicInfoTable.cnic,
          basicInfoTable.fatherName,
          basicInfoTable.birthDate,
          basicInfoTable.address,
          cnicFrontImage,
          cnicBackImage,
          vehicleInfoTable.type,
          vehicleInfoTable.brand,
          vehicleInfoTable.number,
          vehicleImage,
          vehicleCertificateImage,
          licenseInfoTable.number,
          licenseInfoTable.expiryDate,
          licenseImage,
          ZERO,
          ZERO));

      _localDataSource.deleteRegisteringData();
      _appPreferences.setDriverProfileDone();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Routes.fetchingDataRoute);
    } on Failure catch (error) {
      setState(() {
        _isLoading = false;
      });

      _fToast.showToast(
          child:
              buildToast(type: ToastMessageType.failure, mes: error.message));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      _fToast.showToast(
          child: buildToast(
              type: ToastMessageType.failure,
              mes: "Something went wrong. Please try again!"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          body: SafeArea(
              child: SizedBox(
            height: getHeight(context: context),
            width: getWidth(context: context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Registeration',
                    style: GoogleFonts.nunito(
                        fontSize: 24,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Create your driver account',
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: themeProvider.getDarkTheme
                            ? Colors.grey[100]
                            : const Color.fromARGB(255, 170, 169, 169),
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  FutureBuilder(
                      future: getData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                              height: getHeight(context: context) -
                                  getHeight(context: context) * 0.33,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ));
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: SizedBox(
                                width: getWidth(context: context),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6)),
                                        onTap: () async {
                                          final result = await Navigator.of(
                                                  context)
                                              .pushNamed(Routes.basicInfoRoute);

                                          if (result == true) {
                                            setState(() {
                                              isBasicInfoDone = true;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 17),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  'Basic Info',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                                Row(
                                                  children: [
                                                    isBasicInfoDone
                                                        ? Image.asset(
                                                            ImageAssets.done,
                                                            height: 30,
                                                            width: 30,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    isBasicInfoDone
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    getIcon()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      Routes.cnicImagesRoute);
                                          if (result == true) {
                                            setState(() {
                                              isCNICImagesDone = true;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 17),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  'CNIC Images',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                                Row(
                                                  children: [
                                                    isCNICImagesDone
                                                        ? Image.asset(
                                                            ImageAssets.done,
                                                            height: 30,
                                                            width: 30,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    isCNICImagesDone
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    getIcon()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      Routes.vehicleInfoRoute);
                                          if (result == true) {
                                            setState(() {
                                              isVehicleInfoDone = true;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 17),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  'Vehicle Info',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                                Row(
                                                  children: [
                                                    isVehicleInfoDone
                                                        ? Image.asset(
                                                            ImageAssets.done,
                                                            height: 30,
                                                            width: 30,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    isVehicleInfoDone
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    getIcon()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final result = await Navigator.of(
                                                  context)
                                              .pushNamed(
                                                  Routes.vehicleImagesRoute);
                                          if (result == true) {
                                            setState(() {
                                              isVehicleImagesDone = true;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 17),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  'Vehicle Images',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                                Row(
                                                  children: [
                                                    isVehicleImagesDone
                                                        ? Image.asset(
                                                            ImageAssets.done,
                                                            height: 30,
                                                            width: 30,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    isVehicleImagesDone
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    getIcon()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      InkWell(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        onTap: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                      Routes.licenseInfoRoute);
                                          if (result == true) {
                                            setState(() {
                                              isLicenseInfoDone = true;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 17),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  'License Info',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                                Row(
                                                  children: [
                                                    isLicenseInfoDone
                                                        ? Image.asset(
                                                            ImageAssets.done,
                                                            height: 30,
                                                            width: 30,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    isLicenseInfoDone
                                                        ? const SizedBox(
                                                            width: 5,
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    getIcon()
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 55,
                              width: getWidth(context: context) * 0.6,
                              child: _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        if (!isBasicInfoDone ||
                                            !isCNICImagesDone ||
                                            !isVehicleInfoDone ||
                                            !isVehicleImagesDone ||
                                            !isLicenseInfoDone) {
                                          _fToast.showToast(
                                              child: buildToast(
                                                  type:
                                                      ToastMessageType.failure,
                                                  mes:
                                                      'Please fill out all the fields to create an account'));
                                        }
                                      },
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          onPressed: (isBasicInfoDone &&
                                                  isCNICImagesDone &&
                                                  isVehicleInfoDone &&
                                                  isVehicleImagesDone &&
                                                  isLicenseInfoDone)
                                              ? () {
                                                  _createDriverAccount();
                                                }
                                              : null,
                                          child: Text(
                                            'Submit',
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
          )),
        ),
      );
    });
  }
}
