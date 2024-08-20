import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mentorapp/AppScreens/startingScreens/loadingscreen.dart';
import 'Utils/utils.dart';
import 'firebase_options.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ZIMKit().init(appID: Utils.appID, appSign: Utils.appSign);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        title: 'Mentor App',
        home: LoadingScreen(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(360, 640),
    );
  }
}

/// for admin

// import 'package:mentorapp/AppScreens/Admin/adminlogin.dart';
// import 'package:mentorapp/AppScreens/Admin/mentees.dart';
// import 'package:mentorapp/AppScreens/Admin/mentors.dart';
// import 'package:mentorapp/AppScreens/Admin/organization.dart';
// // import 'package:mentorapp/Utils/utils.dart';
// import 'package:sizer/sizer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:mentorapp/AppScreens/Admin/layoutscreen.dart';
// // import 'package:zego_zimkit/zego_zimkit.dart';
// import 'AppScreens/Admin/adminhome.dart';
// import 'AppScreens/Admin/dashboard.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//           apiKey: "AIzaSyBCiOaMjito_tXLi033vDQZLSti3vnQU18",
//           authDomain: "fypproject-cf2ac.firebaseapp.com",
//           databaseURL: "https://fypproject-cf2ac-default-rtdb.firebaseio.com",
//           projectId: "fypproject-cf2ac",
//           storageBucket: "fypproject-cf2ac.appspot.com",
//           messagingSenderId: "389414759725",
//           appId: "1:389414759725:web:7ab08e8c5e735d6f58f7a4",
//           measurementId: "G-BJP1DLP95Z"),
//     );
//   } else {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//   // await ZIMKit().init(appID: Utils.appID, appSign: Utils.appSign);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.light,
//   ));
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (BuildContext context, Orientation orientation,
//               DeviceType deviceType) =>
//           GetMaterialApp(
//         title: 'Mentor App',
//         home: const LayoutScreen(),
//         routes: {
//           AdminLogin.id: (context) => AdminLogin(),
//           AdminPanel.id: (context) => AdminPanel(),
//           Dashboard.id: (context) => Dashboard(),
//           Organization.id: (context) => Organization(),
//           Mentor.id: (context) => Mentor(),
//           Mentee.id: (context) => Mentee(),
//         },
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
