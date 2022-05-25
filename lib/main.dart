import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metro_media/providers/user_provider.dart';
import 'package:metro_media/responsiveLayout/mobile_screen_layout.dart';
import 'package:metro_media/responsiveLayout/responsive_layout_screen.dart';
import 'package:metro_media/responsiveLayout/web_screen_layout.dart';
import 'package:metro_media/screens/login_screen.dart';
import 'package:metro_media/screens/signup_screen.dart';
import 'package:metro_media/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC_AX-SvA7TVem3Ga0yvJ5YF88oPnR8B6k",
         appId: "1:1069308389558:web:d48439f69f541085435e17", 
         messagingSenderId: "1069308389558", 
         projectId: "metromedia-d7d31",
         storageBucket: "metromedia-d7d31.appspot.com",
         ),
    );
  }
  else{
    await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        title: 'Metro Media',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
                );
            }else if (snapshot.hasError) {
              return  Center(
                child: Text('${snapshot.error}'),
              );
            }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
           return const LoginScreen(); 
}

  
          
        ),
        // home: const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),
      ),
    );
  }
}