import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metro_media/resources/auth_methods.dart';
import 'package:metro_media/screens/signup_screen.dart';
import 'package:metro_media/utils/colors.dart';
import 'package:metro_media/utils/utils.dart';
import 'package:metro_media/widgets/text_field_input.dart';

import '../responsiveLayout/mobile_screen_layout.dart';
import '../responsiveLayout/responsive_layout_screen.dart';
import '../responsiveLayout/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  // }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
      );
    
    if(res == 'success'){
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
           MaterialPageRoute(
             builder: (context) => const ResponsiveLayout(
               webScreenLayout: WebScreenLayout(),
               mobileScreenLayout: MobileScreenLayout(),
               ),
             ),
      );

    }else{
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
      
  }

  navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const SignUpScreen())));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex:2),
              //svgimage,
              // SvgPicture.asset(
              //   "assets/metromedia.svg",
              //   color: primaryColor,
              //   height: 64,
              //   ),
              Image.network("https://scontent.xx.fbcdn.net/v/t1.15752-9/280758299_5100803176670652_2791107785041810343_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=aee45a&_nc_eui2=AeE72ifAWk2vYhcyJWWodaosMR8jpvle7IsxHyOm-V7six-gxPVs4vbsjIgZjITHpzmMGtOaj7krm_INzGE2A5Sm&_nc_ohc=D-PJcP_Yao0AX-UChvS&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_AVJZdYjCF8s0RPc2jR7lrd5llOkJfEoBzrnX7OefBgrjkQ&oe=62ACFF33"),

              const SizedBox(height: 32,),
              //emailtextfield
              TextFieldInput(
                textEditingController: _emailController ,
                hintText: 'Please Enter your email',
                textInputType: TextInputType.emailAddress,
                ),
              const SizedBox(height:24),
              //passtextfield
              TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter Your Password',
              textInputType: TextInputType.text,
              isPass: true,
              ),
              const SizedBox(height:24),
              //button
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading? const Center(child: CircularProgressIndicator(
                    color: primaryColor,
                  )) :const Text("Log In"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                    ),
                    
                ),
              ),
              Flexible(child:Container(),flex:2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    child: const Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text('SignUp',style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
              ])
              
            ],
          ),
          
        ),
        ),
      
    );
  }
}