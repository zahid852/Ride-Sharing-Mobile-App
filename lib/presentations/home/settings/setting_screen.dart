import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/app/di.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:lift_app/presentations/resources/routes_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final void Function() menuButtonFunction;
  const SettingsScreen({Key? key, required this.menuButtonFunction})
      : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
        return Column(
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
                      'Settings',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                    title: Text(
                      'Profile',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.profileRoute);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(IconlyBold.profile),
                    ),
                  ),
                  CommonData.passengerDataModal.isDriver
                      ? Column(
                          children: [
                            const Divider(
                              height: 1,
                            ),
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 10, 15, 10),
                              title: Text(
                                'Reviews',
                                style: GoogleFonts.nunito(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.reviewsRoute);
                              },
                              leading: const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(Icons.reviews),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const Divider(
                    height: 1,
                  ),
                  SwitchListTile(
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                      // activeTrackColor: Colors.blue,
                      // inactiveThumbColor: Colors.white,
                      // inactiveTrackColor: Colors.blue,
                      // activeColor: Colors.white,

                      title: Text(
                        themeProvider.getDarkTheme ? 'Dark' : 'Light',
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      secondary: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          themeProvider.getDarkTheme
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                      ),
                      value: themeProvider.getDarkTheme,
                      onChanged: (bool value) {
                        themeProvider.setDarkTheme = value;
                      }),
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      _appPreferences.logout();
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.getOtpRoute);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(IconlyBold.logout),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ));
  }
}
