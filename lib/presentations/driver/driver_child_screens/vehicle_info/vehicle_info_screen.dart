import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/vehicle_info/vehicle_info_viewmodel.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../../app/di.dart';
import '../../../../data/data_source/local_data_source.dart';
import '../../../../data/mapper/mappers.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final TextEditingController _vehicleNumberEditingController =
      TextEditingController();
  final TextEditingController _vehicleBrandEditingController =
      TextEditingController();
  final List<String> vehicleTypeList = ['Motorbike', 'Car'];
  late String _vehilceType;
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final VehicleInfoViewModel _vehicleInfoViewModel = VehicleInfoViewModel();
  VehicleInfoModel? _vehicleInfoModel;
  bool _isVehicleInfoButtonValidInitially = false;
  final _formKey = GlobalKey<FormState>();
  late Future getData;
  _bind() {
    _vehicleNumberEditingController.addListener(() =>
        _vehicleInfoViewModel.setNumber(_vehicleNumberEditingController.text));
    _vehicleBrandEditingController.addListener(() =>
        _vehicleInfoViewModel.setBrand(_vehicleBrandEditingController.text));
  }

  @override
  void initState() {
    _bind();
    _vehilceType = vehicleTypeList[1];

    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    _vehicleInfoModel = await _localDataSource
        .read(LocalDataSourceConstants.vehicleInfoTable) as VehicleInfoModel?;

    if (_vehicleInfoModel != null) {
      _vehicleBrandEditingController.text = _vehicleInfoModel?.brand ?? EMPTY;
      _vehilceType = _vehicleInfoModel?.type ?? vehicleTypeList[1];
      _vehicleNumberEditingController.text = _vehicleInfoModel?.number ?? EMPTY;
      _isVehicleInfoButtonValidInitially = true;
    }
  }

  @override
  void dispose() {
    _vehicleNumberEditingController.dispose();

    _vehicleBrandEditingController.dispose();
    _vehicleInfoViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
        return WillPopScope(
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
                              'Vehicle Info',
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
                                            height: getHeight(
                                                    context: context) -
                                                getHeight(context: context) *
                                                    0.2,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ));
                                      }
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 10, 20, 20),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: Form(
                                                key: _formKey,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 14,
                                                      vertical: 15),
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      DropdownButtonFormField(
                                                          dropdownColor:
                                                              themeProvider
                                                                      .getDarkTheme
                                                                  ? Colors.grey[
                                                                      800]
                                                                  : Colors
                                                                      .white,
                                                          iconEnabledColor:
                                                              themeProvider
                                                                      .getDarkTheme
                                                                  ? Colors.grey[
                                                                      300]
                                                                  : Colors.grey,
                                                          elevation: 2,
                                                          value: _vehilceType,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          onSaved: (value) {},
                                                          decoration:
                                                              const InputDecoration(
                                                            prefixIcon: Icon(
                                                              Icons
                                                                  .category_rounded,
                                                              size: 25,
                                                            ),
                                                            label: Text("TYPE"),
                                                          ),
                                                          selectedItemBuilder:
                                                              (BuildContext
                                                                  context) {
                                                            return vehicleTypeList
                                                                .map((String
                                                                    value) {
                                                              return Text(
                                                                value,
                                                              );
                                                            }).toList();
                                                          },
                                                          items: vehicleTypeList
                                                              .map((item) {
                                                            return DropdownMenuItem(
                                                                value: item,
                                                                child: Text(
                                                                  item,
                                                                ));
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _vehilceType =
                                                                  value!;
                                                            });
                                                          },
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return 'Select vehicle type';
                                                            } else {
                                                              return null;
                                                            }
                                                          }),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _vehicleBrandEditingController,
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 2),
                                                            child: Icon(
                                                              Icons
                                                                  .branding_watermark_outlined,
                                                              size: 25,
                                                            ),
                                                          ),
                                                          label: Text('BRAND'),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Enter brand';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _vehicleNumberEditingController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 6),
                                                            child: Icon(
                                                              Icons.numbers,
                                                              size: 25,
                                                            ),
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
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 55,
                                            width: getWidth(context: context) *
                                                0.6,
                                            child: StreamBuilder<bool>(
                                                initialData:
                                                    _isVehicleInfoButtonValidInitially,
                                                stream: _vehicleInfoViewModel
                                                    .outputIsAllInputValid,
                                                builder: (context, snapshot) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (snapshot.data ==
                                                          false) {
                                                        _formKey.currentState!
                                                            .validate();
                                                      }
                                                    },
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20))),
                                                        onPressed:
                                                            snapshot.data ??
                                                                    false
                                                                ? () {
                                                                    _formKey
                                                                        .currentState!
                                                                        .validate();
                                                                    _localDataSource
                                                                        .insert(
                                                                            LocalDataSourceConstants.vehicleInfoTable,
                                                                            VehicleInfoModel(
                                                                              _appPreferences.getUserId(),
                                                                              _vehilceType,
                                                                              _vehicleBrandEditingController.text,
                                                                              _vehicleNumberEditingController.text,
                                                                            ));

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  }
                                                                : null,
                                                        child: Text(
                                                          'Done',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        )),
                                                  );
                                                }),
                                          ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        )
                      ])))),
        );
      }),
    );
  }
}
