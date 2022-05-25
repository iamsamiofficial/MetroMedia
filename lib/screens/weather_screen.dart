import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:metro_media/utils/colors.dart';


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var temp;
  var description;
  var current;
  var humidity;
  var windSpeed;
  var country;
  var division;

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=sylhet&appid=0dd63a91865963b51df0326fd40caa75"));
    var results = jsonDecode(response.body); 
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results["weather"][0]["description"];
      this.current = results["weather"][0]["main"];
      this.humidity = results["main"]["humidity"];
      this.windSpeed = results["wind"]["speed"];
      this.country = results["sys"]["country"];
      this.division = results["name"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body:Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding:EdgeInsets.all(10.0),
                  child: Text(
                    "Currently in Sylhet",
                    style:  TextStyle(
                      //color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   ),
                   Text(
                     temp != null ? temp.toString()+"\u00B0" : "Loading",
                     style: const TextStyle(
                       //color: Colors.white,
                       fontSize: 40.00,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                   Padding(
                  padding:const EdgeInsets.all(10.0),
                  child: Text(
                    current != null? current.toString():"Loading",
                    style: const TextStyle(
                      //color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   ),
              ],
    
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListTile(
                    // leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    leading: const FaIcon(FontAwesomeIcons.thermometerHalf,color: Colors.white,),
                    title: const Text("Temperature",style: TextStyle(color: Colors.white),),
                    trailing: Text(temp != null ? temp.toString()+"\u00B0" : "Loading",style: const TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.cloud,color: Colors.white,),
                    title: const Text("Weather",style: TextStyle(color: Colors.white),),
                    trailing: Text(description != null ? description.toString():"Loading",style: const TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.sun,color: Colors.white,),
                    title: const Text("TemperaHumidityture",style: TextStyle(color: Colors.white),),
                    trailing: Text(humidity != null ? humidity.toString():"Loading",style: const TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.wind,color: Colors.white,),
                    title: const Text("Wind Speed",style: TextStyle(color: Colors.white),),
                    trailing: Text(windSpeed != null ? windSpeed.toString():"Loading",style: const TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    leading: const FaIcon(FontAwesomeIcons.flag,color: Colors.white,),
                    title: Text(country != null ? country.toString() : "Loading",style: const TextStyle(color: Colors.white),),
                    trailing: Text(division != null ? division.toString():"Loading",style: const TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              ),
              ),
        ],
        
      )
      ),
    );
  }
}