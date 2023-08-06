import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/app/services.dart';
import 'package:lift_app/data/request/request.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/passenger/profile_viewmodel.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/network/failure.dart';

class PassengerProfileScreen extends StatefulWidget {
  const PassengerProfileScreen({Key? key}) : super(key: key);

  @override
  State<PassengerProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PassengerProfileScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _cityEditingController = TextEditingController();
  List<String> genderList = ['Male', 'Female'];
  List<String> profileType = ['Passenger', 'Driver'];
  File? _image;
  final FToast _fToast = FToast();
  bool _isLoading = false;
  String? _gender;
  bool? _profile;
  bool? _isImageAddedOnValidation;
  final _formKey = GlobalKey<FormState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final ProfileViewModel _profileViewModel = ProfileViewModel();
  _bind() {
    _nameEditingController.addListener(
        () => _profileViewModel.setName(_nameEditingController.text));
    _emailEditingController.addListener(
        () => _profileViewModel.setEmail(_emailEditingController.text));
    _cityEditingController.addListener(
        () => _profileViewModel.setCity(_cityEditingController.text));
  }

  @override
  void initState() {
    _bind();
    _fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _cityEditingController.dispose();
    _profileViewModel.dispose();

    super.dispose();
  }

  void _createAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _profileViewModel.registerUser(RegisterPassengerRequest(
          _nameEditingController.text,
          _emailEditingController.text,
          _appPreferences.getUserId(),
          _cityEditingController.text,
          _gender!,
          _profile!,
          _image!));
      _appPreferences.setPassengerProfileDone();
      if (!mounted) return;
      if (_profile == true) {
        _appPreferences.setUserAsDriver();
        Navigator.of(context).pushReplacementNamed(Routes.driverProfileRoute);
      } else if (_profile == false) {
        Navigator.of(context).pushReplacementNamed(Routes.fetchingDataRoute);
      }
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

  void _getPhotoFromCamera() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await cropImage(imageFile: _image!);
      setState(() {});
    }
  }

  void _getPhotoFromGallery() async {
    Navigator.of(context).pop();
    final imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await cropImage(imageFile: _image!);
      setState(() {});
    }
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Profile Setup',
                      style: GoogleFonts.nunito(
                          fontSize: 24,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Create a new account',
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
                    Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _image == null
                                      ? Image.asset(ImageAssets.emptyImage)
                                          .image
                                      : FileImage(_image!)),
                              shape: BoxShape.circle),
                          width: 120,
                        ),
                        Positioned(
                            bottom: 7,
                            right: 7,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        titlePadding: const EdgeInsets.only(
                                            left: 0, right: 0, top: 0),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 24,
                                                  right: 35,
                                                  top: 25,
                                                  bottom: 10),
                                              child: Text(
                                                'Choose option',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 20,
                                                    color:
                                                        Colors.lightGreen[400],
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Icon(
                                                  Icons.camera,
                                                ),
                                              ),
                                              minLeadingWidth: 25,
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 70),
                                                child: Text(
                                                  'Take a picture',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              onTap: _getPhotoFromGallery,
                                              leading: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Icon(Icons.photo),
                                              ),
                                              minLeadingWidth: 28,
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 70),
                                                child: Text(
                                                  'Photo from gallery',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Center(
                                      child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ))),
                            ))
                      ],
                    ),
                    _isImageAddedOnValidation == false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.image,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Add image',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: getWidth(context: context) * 0.85,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameEditingController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter name";
                                  }

                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    IconlyBold.profile,
                                    size: 25,
                                  ),
                                  label: Text(
                                    'NAME',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                controller: _emailEditingController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter email';
                                  }
                                  if (!isEmailValid(value)) {
                                    return "Enter valid email";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 25,
                                  ),
                                  label: Text('EMAIL'),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                controller: _cityEditingController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter city";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(bottom: 3),
                                    child: Icon(
                                      IconlyBold.location,
                                      size: 25,
                                    ),
                                  ),
                                  label: Text('CITY'),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField(
                                    dropdownColor: themeProvider.getDarkTheme
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    iconEnabledColor: themeProvider.getDarkTheme
                                        ? Colors.grey[300]
                                        : Colors.grey,
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    onSaved: (value) {
                                      // data['type'] = value.toString();
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: Icon(
                                          MdiIcons.human,
                                          size: 25,
                                        ),
                                      ),
                                      label: const Text("GENDER"),
                                    ),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return genderList.map((String value) {
                                        return Text(
                                          value,
                                        );
                                      }).toList();
                                    },
                                    items: genderList.map((item) {
                                      return DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select gender';
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField(
                                    dropdownColor: themeProvider.getDarkTheme
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    iconEnabledColor: themeProvider.getDarkTheme
                                        ? Colors.grey[300]
                                        : Colors.grey,
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    onSaved: (value) {
                                      // data['type'] = value.toString();
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
                                        child: Icon(
                                          MdiIcons.car,
                                          size: 25,
                                        ),
                                      ),
                                      label: Text("PROFILE TYPE"),
                                    ),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return profileType.map((String value) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.start,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    items: profileType.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value == 'Passenger') {
                                        _profile = false;
                                      } else if (value == 'Driver') {
                                        _profile = true;
                                      }
                                      setState(() {});
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select profile type';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        height: 50,
                        width: getWidth(context: context) * 0.85,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : StreamBuilder(
                                stream: _profileViewModel.outputIsAllInputValid,
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (snapshot.data == false ||
                                          _gender == null ||
                                          _profile == null) {
                                        _formKey.currentState!.validate();
                                        FocusScope.of(context).unfocus();
                                      }
                                      if (_image == null) {
                                        _formKey.currentState!.validate();
                                        setState(() {
                                          _isImageAddedOnValidation = false;
                                        });
                                        FocusScope.of(context).unfocus();
                                      }
                                      if (_image != null &&
                                          _isImageAddedOnValidation == false) {
                                        setState(() {
                                          _isImageAddedOnValidation = true;
                                        });
                                      }
                                    },
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        onPressed: (snapshot.data == false ||
                                                snapshot.data == null ||
                                                _image == null ||
                                                _gender == null ||
                                                _profile == null)
                                            ? null
                                            : () {
                                                _isImageAddedOnValidation ==
                                                        false
                                                    ? setState(() {
                                                        _isImageAddedOnValidation =
                                                            true;
                                                      })
                                                    : const SizedBox.shrink();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                _formKey.currentState!
                                                    .validate();
                                                _createAccount();
                                              },
                                        child: const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )),
                                  );
                                }),
                      ),
                    )
                  ],
                ),
              ),
            )),
          ),
        );
      }),
    );
  }
}

// Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton(
//               onPressed: () async {
//                 final imagePicker = ImagePicker();
//                 XFile? pickedFile =
//                     await imagePicker.pickImage(source: ImageSource.gallery);
//                 log('$pickedFile hl');
//                 if (pickedFile != null) {
//                   // WidgetsBinding.instance.addPostFrameCallback((_) {
//                   setState(() {
//                     _image = File(pickedFile.path);
//                     //   });
//                   });
//                 }
//               },
//               child: Text('pick image')),
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: _image == null
//                         ? Image.asset('assets/images/empty_image.jpg').image
//                         : FileImage(_image!)),
//                 shape: BoxShape.circle),
//             width: 120,
//           ),
//           TextButton(
//               onPressed: () async {
//                 setState(() {
//                   isLoading = true;
//                 });
//                 try {
//                   await _profileViewModel.registerUser(RegisterUserRequest(
//                       'Zahid',
//                       'zahidyousaf377699@gmail.com',
//                       GlobalUserId!,
//                       'Multan',
//                       'Male',
//                       false,
//                       _image!));
//                   // showMessage(context, 'Successfully saved', Colors.green);
//                 } on Failure catch (error) {
//                   log('failure error ${error.message} ${error.code}');
//                   setState(() {
//                     isLoading = false;
//                   });
//                   // showMessage(context, error.message, Colors.red);
//                 } catch (error) {
//                   log('common error ${error}');
//                   setState(() {
//                     isLoading = false;
//                   });
//                   // showMessage(context, "Something went wrong.Please try again!",
//                   // Colors.red);
//                 }
//               },
//               child: Text('save'))
//         ],
//       )),
//     );
