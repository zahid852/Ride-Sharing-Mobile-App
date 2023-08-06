import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/home/settings/components/theme_provider.dart';
import 'package:provider/provider.dart';

class ListTileWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function function;
  final bool isActive;
  const ListTileWidget(
      {super.key,
      required this.label,
      required this.icon,
      required this.function,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? Colors.lightGreen.withOpacity(0.8)
              : Colors.grey.withOpacity(0.5),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4.5,
        ),
        child: ListTile(
          leading: Icon(
            icon,
          ),
          onTap: () {
            function();
          },
          horizontalTitleGap: 0,
          title: Text(
            label,
            style:
                GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      );
    });
  }
}
