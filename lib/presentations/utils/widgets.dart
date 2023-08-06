import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/resources/assets_manager.dart';
import 'package:lift_app/presentations/utils/utils.dart';
import 'package:lottie/lottie.dart';

class ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    Offset cp = Offset(size.width / 2, size.height);
    Offset ep = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(cp.dx, cp.dy, ep.dx, ep.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class InvisibleExpandedHeader extends StatefulWidget {
  final Widget child;
  const InvisibleExpandedHeader({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  _InvisibleExpandedHeaderState createState() {
    return _InvisibleExpandedHeaderState();
  }
}

class _InvisibleExpandedHeaderState extends State<InvisibleExpandedHeader> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible ?? false,
      child: widget.child,
    );
  }
}

Widget getLoadingWidget(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(bottom: getHeight(context: context) * 0.07),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: 200,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset(
                  LottieAssets.loading,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Please wait',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget showProfileAppBar(BuildContext context) {
  return Container(
    height: getHeight(context: context) * 0.07,
    alignment: Alignment.center,
    color: Colors.lightGreen,
    child: Stack(
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
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 28,
                ))),
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 40),
          child: Text(
            'Profile',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}
