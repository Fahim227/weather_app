import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.locationData});
  final locationData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  late int temperature;
  late int condition;
  late String countryName;
  late String emoji;
  late String message;

  WeatherModel weatherModel = WeatherModel();

  void updateUI(dynamic weatherData){

    if(weatherData == null){
      temperature = 0;
      emoji ='Error';
      message = 'There is some problem on Connecting';
      return;
    }
    double temp = weatherData['main']['temp'];
    condition = weatherData['weather'][0]['id'];
    print(condition);
    temperature = temp.toInt()-273;
    print(temperature);
    emoji = weatherModel.getWeatherIcon(condition);
    message = weatherModel.getMessage(temperature);
  }

  @override
  void initState()  {
    super.initState();
    updateUI(widget.locationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weather = await weatherModel.getLocationData();
                      updateUI(weather);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context, MaterialPageRoute(builder: (context)=> CityScreen()));
                      if (typedName != null){
                        var data = await weatherModel.getCityData(typedName);
                        print(data);
                        updateUI(data);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$emoji',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
