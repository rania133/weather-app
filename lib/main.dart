
import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_model.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Egypt Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  String _city = 'Cairo';
  bool _isLoading = false;

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Weather weather = await _weatherService.getWeather(_city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // Handle errors (e.g., show a dialog)
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather in Egypt'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _weather != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather!.cityName,
              style: const TextStyle(fontSize: 32),
            ),
            Text(
              '${_weather!.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(fontSize: 48),
            ),
            Text(
              _weather!.description,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            _buildCitySelector(),
          ],
        )
            : const Text('Enter a city name.'),
      ),
    );
  }

  Widget _buildCitySelector() {
    List<String> cities = [
      'Cairo',
      'Alexandria',
      'Giza',
      'Luxor',
      'Aswan',
      'Sharm El Sheikh',
      // Add more cities as needed
    ];

    return DropdownButton<String>(
      value: _city,
      onChanged: (String? newValue) {
        setState(() {
          _city = newValue!;
          _fetchWeather();
        });
      },
      items: cities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
