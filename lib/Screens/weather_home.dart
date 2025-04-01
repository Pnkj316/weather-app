import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/weather_services/weather_services.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;
  bool citiesLoaded = false;

  List<Map<String, dynamic>> cities = [];
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );

    fetchCities();
  }

  void myWeather(double lat, double lon) {
    setState(() {
      isLoading = false;
    });
    WeatherServices().fetchWeather(lat, lon).then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = true;
      });
    });
  }

  void fetchCities() async {
    List<Map<String, dynamic>> cityData = [
      {"name": "Sirsa", "lat": 29.536535, "lon": 75.025505},
      {"name": "Gurugram", "lat": 28.4665886, "lon": 77.0333116},
      {"name": "Hisar", "lat": 29.1657062, "lon": 75.7186069},
      {"name": "Delhi", "lat": 28.679079, "lon": 77.069710},
    ];

    setState(() {
      cities = cityData;
      selectedCity = cities.first['name'];
      myWeather(cities.first['lat'], cities.first['lon']);
      citiesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 88, 169, 234),
        body: Padding(
          padding: EdgeInsets.all(15.w),
          child: citiesLoaded
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        dropdownColor: Colors.blue[300],
                        value: selectedCity,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue;
                            final selectedCityData = cities.firstWhere(
                                (city) => city['name'] == selectedCity);

                            myWeather(selectedCityData['lat'],
                                selectedCityData['lon']);
                          });
                        },
                        items: cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city['name'],
                            child: Text(
                              city['name'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: isLoading
                            ? WeatherDetail(
                                weather: weatherInfo,
                                formattedDate: formattedDate,
                                formattedTime: formattedTime,
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: TextStyle(
            fontSize: 25.sp,
            color: const Color.fromARGB(255, 88, 169, 234),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: TextStyle(
            fontSize: 40.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        SizedBox(height: 30.h),
        Text(
          formattedDate,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          height: 200.h,
          width: 200.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          height: 250.h,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 24, 145, 245),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherIconInfo(
                      icon: Icons.wind_power,
                      title: "Wind",
                      value: "${weather.wind.speed} km/h",
                    ),
                    _buildWeatherIconInfo(
                      icon: Icons.sunny,
                      title: "Max",
                      value: "${weather.maxTemperature.toStringAsFixed(2)}°C",
                    ),
                    _buildWeatherIconInfo(
                      icon: Icons.wind_power,
                      title: "Min",
                      value: "${weather.minTemperature.toStringAsFixed(2)}°C",
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeatherIconInfo(
                      icon: Icons.water_drop,
                      title: "Humidity",
                      value: "${weather.humidity}%",
                    ),
                    _buildWeatherIconInfo(
                      icon: Icons.air,
                      title: "Pressure",
                      value: "${weather.pressure} hPa",
                    ),
                    _buildWeatherIconInfo(
                      icon: Icons.leaderboard,
                      title: "Sea-Level",
                      value: "${weather.seaLevel} m",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _buildWeatherIconInfo(
      {required IconData icon, required String title, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
