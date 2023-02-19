import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';
import 'package:weather_app/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temperature;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;

  List favoriteCities = [];

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature!);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         color: Colors.grey
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        var weatherData = await weather.getLocationWeather();
                        updateUI(weatherData);
                      },
                      icon: const Icon(
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityScreen()
                            ,
                          ),
                        );
                        if (typedName != null) {
                          var weatherData =
                          await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in',
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('$cityName',
                    style: kMessageTextStyle,),
                  ElevatedButton(
                      onPressed: (){
                        favoriteCities.add(cityName);
                        // print("the city name $cityName $favoriteCities");
                        setState(() {});
                      }, child: Text("Add to ❤"))
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("Your  favorite cities:",
                textAlign: TextAlign.left,
                style: kFavoriteTextStyle,),
              ),
              Expanded(
                child: Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount:favoriteCities.isEmpty?1 :favoriteCities.length,
                      itemBuilder: (BuildContext context,index){
                    return favoriteCities.isEmpty?Text("No favoriteCities",style:kFavoriteTextStyle ,)
                        : Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:  [
                            Text('${favoriteCities[index]}',
                              style: kTextStyle,),
                            // Text(
                            //   '$temperature°',
                            //   style: kTextStyle,
                            // ),
                            IconButton(onPressed: (){
                              favoriteCities.removeAt(index);
                              setState(() {
                              });
                            }, icon: Icon(Icons.highlight_remove_outlined))
                          ],
                        )
                    );
                  }),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}