
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_page.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      checkRedirection();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff16202a),
        /* gradient: LinearGradient(
          colors: homepageGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),*/
        image: DecorationImage(
          image: AssetImage(
            "assets/images/splashscreen.gif",
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* Image.asset(
              "assets/images/logo.png",
              width: MediaQuery.of(context).size.width ,
            ),
            NearLoadingIndicator(
              Indicator.ballPulse,
              colors: nearRedButtonGradient,
            )*/
          ],
        ),
      ),
    );
  }

  checkRedirection() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email =  prefs.getString("email");
    if (email != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListView(),
          ));

    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
      // Get.off(
      //   Home(0,0
      //     /* userData['user_id'],
      //   userData['username'],
      //   userData['email_id'],
      //   userData['access_token'],
      //   'null',*/
      //   ),
      // );
    }
  }

}
