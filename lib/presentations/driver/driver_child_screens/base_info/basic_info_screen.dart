import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/data/mapper/mappers.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:lift_app/presentations/driver/driver_child_screens/base_info/base_info_viewmodel.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../data/data_source/local_data_source.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final TextEditingController _cnicEditingController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '#####-#######-#');

  final TextEditingController _fatherNameEditingController =
      TextEditingController();
  final TextEditingController _birthdayEditingController =
      TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final BaseInfoViewModel _baseInfoViewModel = BaseInfoViewModel();
  BasicInfoModel? _basicInfoModel;
  bool _isBasicInfoButtonValidInitially = false;
  final _formKey = GlobalKey<FormState>();
  late Future getData;
  bool? _isBirthDateEmptyOnValidation;
  _bind() {
    _cnicEditingController.addListener(
        () => _baseInfoViewModel.setCNIC(_cnicEditingController.text));
    _fatherNameEditingController.addListener(() =>
        _baseInfoViewModel.setFatherName(_fatherNameEditingController.text));
    _birthdayEditingController.addListener(
        () => _baseInfoViewModel.setBirthDate(_birthdayEditingController.text));
    _addressEditingController.addListener(
        () => _baseInfoViewModel.setAddress(_addressEditingController.text));
  }

  @override
  void initState() {
    _bind();

    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    _basicInfoModel = await _localDataSource
        .read(LocalDataSourceConstants.basicInfoTable) as BasicInfoModel?;

    if (_basicInfoModel != null) {
      _cnicEditingController.text = _basicInfoModel?.cnic ?? EMPTY;
      _fatherNameEditingController.text = _basicInfoModel?.fatherName ?? EMPTY;
      _birthdayEditingController.text = _basicInfoModel?.birthDate ?? EMPTY;
      _addressEditingController.text = _basicInfoModel?.address ?? EMPTY;
      _isBasicInfoButtonValidInitially = true;
    }
  }

  @override
  void dispose() {
    _cnicEditingController.dispose();
    _fatherNameEditingController.dispose();
    _birthdayEditingController.dispose();
    _addressEditingController.dispose();
    _baseInfoViewModel.dispose();
    super.dispose();
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
                      'Basic Info',
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
                                        20, 10, 20, 20),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 15),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter cnic';
                                                  }
                                                  return null;
                                                },
                                                controller:
                                                    _cnicEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  maskFormatter
                                                ],
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    MdiIcons
                                                        .cardAccountDetailsOutline,
                                                    size: 25,
                                                  ),
                                                  label: const Text('CNIC'),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              TextFormField(
                                                controller:
                                                    _fatherNameEditingController,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Icon(
                                                    IconlyBold.profile,
                                                    size: 25,
                                                  ),
                                                  label: Text('FATHER NAME'),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter father name';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              TextFormField(
                                                  controller:
                                                      _birthdayEditingController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      setState(() {
                                                        _isBirthDateEmptyOnValidation =
                                                            true;
                                                      });
                                                      return 'Enter birth date';
                                                    }
                                                    setState(() {
                                                      _isBirthDateEmptyOnValidation =
                                                          false;
                                                    });
                                                    return null;
                                                  },
                                                  readOnly: true,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
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
                                                                color:
                                                                    Colors.grey[
                                                                        300]!)),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            _isBirthDateEmptyOnValidation ==
                                                                    true
                                                                ? Colors.red
                                                                : Colors
                                                                    .lightGreen,
                                                      ),
                                                      iconSize: 30,
                                                      onPressed: () async {
                                                        final DateTime? date =
                                                            await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: _basicInfoModel !=
                                                                        null
                                                                    ? DateFormat(
                                                                            "dd/MM/yyyy")
                                                                        .parse(_basicInfoModel!
                                                                            .birthDate)
                                                                    : DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100));
                                                        if (date != null) {
                                                          _birthdayEditingController
                                                              .text = DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(date);
                                                        }
                                                      },
                                                    ),
                                                    label: const Text(
                                                        'BIRTH DATE'),
                                                  )),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              TextFormField(
                                                controller:
                                                    _addressEditingController,
                                                maxLines: 5,
                                                minLines: 1,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Enter address';
                                                  }
                                                  return null;
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Icon(
                                                    IconlyBold.location,
                                                    size: 25,
                                                  ),
                                                  label: Text('ADDRESS'),
                                                ),
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
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 55,
                                        width: getWidth(context: context) * 0.6,
                                        child: StreamBuilder<bool>(
                                            initialData:
                                                _isBasicInfoButtonValidInitially,
                                            stream: _baseInfoViewModel
                                                .outputIsAllInputValid,
                                            builder: (ctx, snapshot) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if (snapshot.data == false) {
                                                    _formKey.currentState!
                                                        .validate();
                                                    FocusScope.of(context)
                                                        .unfocus();
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
                                                        snapshot.data ?? false
                                                            ? () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                _formKey
                                                                    .currentState!
                                                                    .validate();
                                                                _localDataSource.insert(
                                                                    LocalDataSourceConstants
                                                                        .basicInfoTable,
                                                                    BasicInfoModel(
                                                                        _appPreferences
                                                                            .getUserId(),
                                                                        _cnicEditingController
                                                                            .text,
                                                                        _fatherNameEditingController
                                                                            .text,
                                                                        _birthdayEditingController
                                                                            .text,
                                                                        _addressEditingController
                                                                            .text));

                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              }
                                                            : null,
                                                    child: Text(
                                                      'Done',
                                                      style: GoogleFonts.nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              );
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
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
}
