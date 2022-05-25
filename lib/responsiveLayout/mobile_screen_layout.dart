import 'package:flutter/material.dart';
import 'package:metro_media/utils/colors.dart';
import 'package:metro_media/utils/golab_variables.dart';


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({ Key? key }) : super(key: key);
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

 @override
 void dispose(){
   super.dispose();
   pageController.dispose();
 }


  

  navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }
  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItem,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
              ),
            label: '',
            backgroundColor: mobileBackgroundColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
              ),
            label: '',
            //backgroundColor: primaryColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primaryColor : secondaryColor,
              ),
            label: '',
            //backgroundColor: primaryColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face,
              color: _page == 3 ? primaryColor : secondaryColor,
              ),
            label: '',
            //backgroundColor: primaryColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
              ),
            label: '',
            //backgroundColor: primaryColor,
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wind_power,
            color: _page == 5 ? primaryColor : secondaryColor,
            ),
            label: '',
            ),
        ],
        onTap: navigationTapped,
        ),
    );
  }
}