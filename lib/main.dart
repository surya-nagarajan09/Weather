import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, title: "Weather App", home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp,
      description,
      currently,
      humidity,
      windSpeed,
      feelsLike,
      place,
      high,
      low,
      query = "Cuddalore",
      min,
      max,
      val;

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/find?q=$query&units=metric&appid=5e0395cf05736bb06fcac97552604d38"));
    var result = jsonDecode(response.body);
    setState(() {
      temp = result['list'][0]['main']['temp'];
      description = result['list'][0]['weather'][0]['description'];
      humidity = result['list'][0]['main']['humidity'];
      windSpeed = result["list"][0]["wind"]['speed'];
      feelsLike = result['list'][0]['main']['feels_like'];
      place = result['list'][0]['name'];
      min = result['list'][0]['main']['temp_min'].toString();
      max = result['list'][0]['main']['temp_max'].toString();
    });
  }

  void handleField(text) {
    var temp = text;
    setState(() {
      val = temp;
    });
  }

  void handleQuery() {
    Navigator.pop(context);
    setState(() {
      query = val;
    });
    if(query != ""){
      getWeather();

    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
    // handleQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.blueAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    tooltip: 'Search city',
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: double.infinity,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 40),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                    ),
                                    onChanged: (text) => handleField(text),
                                  ),
                                ),
                                SizedBox(height: 40),
                                ElevatedButton(
                                  child: const Text('Search'),
                                  onPressed: () => handleQuery(),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.blueAccent,
                                    onSurface: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.0)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(place != null ? place.toString() : "- -",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  )),
              SizedBox(height: 10),
              Text(temp !=null ? temp.round().toString() + " \u2103" : "-",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(max !=null ? "H-$max L-$min": "--",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ))
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                title: Text("Tempratue"),
                trailing: Text(
                    temp != null ? temp.round().toString() + " \u2103" : "-"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.sun),
                title: Text("Feels like"),
                trailing: Text(feelsLike != null
                    ? feelsLike.round().toString() + " \u2103"
                    : "-"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.wind),
                title: Text("Wind"),
                trailing: Text(windSpeed != null
                    ? windSpeed.round().toString() + ' km/hr'
                    : "-"),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.wind),
                title: Text("Humidity"),
                trailing:
                    Text(humidity != null ? humidity.round().toString() : "-"),
              ),
            ],
          ),
        ))
      ],
    ));
  }
}
