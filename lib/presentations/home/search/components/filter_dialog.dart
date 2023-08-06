import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lift_app/presentations/home/search/search_ride_screen.dart';

import 'package:lift_app/presentations/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FilterDialog extends StatefulWidget {
  final void Function(String parameter) changeSearchParameter;
  final void Function(String parameter) changeVehicleParameter;
  final void Function() removeFocus;
  const FilterDialog(
      {Key? key,
      required this.changeSearchParameter,
      required this.changeVehicleParameter,
      required this.removeFocus})
      : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  int _locationSelectedValue = 0;
  int _vehicleTypeSelectedValue = 2;
  void _handleLocationValueChange(int value, StateSetter newSetState) {
    newSetState(() {
      _locationSelectedValue = value;
      if (value == 0) {
        widget.changeSearchParameter(SearchByEnum.From.name);
      } else {
        widget.changeSearchParameter(SearchByEnum.WhereTo.name);
      }
    });
  }

  void _handleVehicleTypeValueChange(int value, StateSetter newSetState) {
    newSetState(() {
      _vehicleTypeSelectedValue = value;
      if (value == 0) {
        widget.changeVehicleParameter(VehicleEnum.Car.name);
      } else if (value == 1) {
        widget.changeVehicleParameter(VehicleEnum.Bike.name);
      } else {
        widget.changeVehicleParameter(VehicleEnum.All.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context: context) * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 5),
        child: InkWell(
          onTap: () {
            widget.removeFocus;
            showDialog(
              context: context,
              builder: (ctx) {
                return StatefulBuilder(builder:
                    (BuildContext statCtx, StateSetter alertDialogSetState) {
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    titlePadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    title: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          color: Colors.lightGreen),
                      width: getWidth(context: context) * 0.75,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.filter_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Filter',
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Location',
                                style: GoogleFonts.nunito(
                                    color: Colors.lightGreen,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'From',
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Radio(
                                          value: 0,
                                          groupValue: _locationSelectedValue,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _handleLocationValueChange(
                                                  val, alertDialogSetState);
                                            }
                                          }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'WhereTo',
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Radio(
                                          value: 1,
                                          groupValue: _locationSelectedValue,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _handleLocationValueChange(
                                                  val, alertDialogSetState);
                                            }
                                          }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2.5),
                                child: Icon(MdiIcons.car),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Vehicle',
                                style: GoogleFonts.nunito(
                                    color: Colors.lightGreen,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          'Car',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Radio(
                                          value: 0,
                                          groupValue: _vehicleTypeSelectedValue,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _handleVehicleTypeValueChange(
                                                  val, alertDialogSetState);
                                            }
                                          }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          'Bike',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Radio(
                                          value: 1,
                                          groupValue: _vehicleTypeSelectedValue,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _handleVehicleTypeValueChange(
                                                  val, alertDialogSetState);
                                            }
                                          }),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          'All',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Radio(
                                          value: 2,
                                          groupValue: _vehicleTypeSelectedValue,
                                          onChanged: (val) {
                                            if (val != null) {
                                              _handleVehicleTypeValueChange(
                                                  val, alertDialogSetState);
                                            }
                                          }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  );
                });
              },
            );
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Text(
                      'Filter',
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 1.5,
                  child: SizedBox(
                    width: 89,
                    child: Container(
                      // thickness: 1,
                      height: 1,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
