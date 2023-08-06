import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lift_app/app/constants.dart';
import 'package:lift_app/presentations/home/drawer/drawer_view_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class AudioCallingScreen extends StatefulWidget {
//   const AudioCallingScreen({Key? key}) : super(key: key);

//   @override
//   State<AudioCallingScreen> createState() => _AudioCallingScreenState();
// }

// final userId = math.Random().nextInt(10000).toString();

// class _AudioCallingScreenState extends State<AudioCallingScreen> {

//   final callIdController = TextEditingController(text: '1');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Calling'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: callIdController,
//               decoration: InputDecoration(
//                 hintText: 'Enter callign id' ,
//                 border: OutlineInputBorder()
//               ),
//             ),
//             SizedBox(height: 20,),
//             TextButton(onPressed: (){
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => AudioCallingPage(callingId: callIdController.text.toString()))) ;
//             }, child: Text('Call'))
//           ],
//         ),
//       ),
//     );
//   }
// }

class AudioCallingScreen extends StatelessWidget {
  final String callingId;
  const AudioCallingScreen({Key? key, required this.callingId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('1234');
    return SafeArea(
        child: Scaffold(
      body: Container(
          child: ZegoUIKitPrebuiltCall(
        appID: Constants.zegoCloudAppId,
        appSign: Constants.zegoCloudAppSignInId,
        userID: CommonData.passengerDataModal.id,
        callID: callingId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..onOnlySelfInRoom = (context) {
            Navigator.pop(context);
          },
        userName: 'Zahid',
      )),
    ));
  }
}
