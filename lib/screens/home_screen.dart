import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../controllers/monitoring_controller.dart';
import '../models/panen_model.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/panen_prediction_item.dart';
import '../controllers/news_controller.dart';
import '../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tanavue/utils/app_colors.dart'; // Added import
import 'package:tanavue/utils/app_strings.dart'; // Added import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = HomeController();
  final MonitoringController monitorController = MonitoringController();

  final NewsController newsController = NewsController();
  List<NewsItem> newsList = [];

  List<PanenPrediction> predictions = [];
  double humidity = 0;
  double tempDHT = 0;
  double tempDS = 0;

  @override
  void initState() {
    super.initState();
    _loadPrediksiPanen();

    newsController.fetchNews().then((items) {
      setState(() {
        newsList = items;
      });
    });

    // Reuse monitoring data
    monitorController.streamPlantData().listen((plantMap) {
      setState(() {
        humidity = plantMap['humidity'];
        tempDHT = plantMap['tempDHT'];
        tempDS = plantMap['tempDS'];
      });
    });
  }

  Future<void> _loadPrediksiPanen() async {
    final result = await controller.fetchPanenPredictions();
    setState(() => predictions = result);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.welcome, style: textStyle.headlineSmall),
                  IconButton(
                    icon:
                        const CircleAvatar(backgroundColor: AppColors.primary),
                    onPressed: () {
                      // TODO: profile navigation
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 180,
                child: newsList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          final news = newsList[index];
                          return GestureDetector(
                            onTap: () => launchUrl(Uri.parse(news.url),
                                mode: LaunchMode.externalApplication),
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(right: 12, left: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.placeholderBg,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(news.imageRef),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.darken),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(news.title,
                                      style: const TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 8),
                                  Text(
                                    news.subtitle,
                                    style: const TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),

              // Monitor Tanaman
              Text(AppStrings.monitorTanaman, style: textStyle.titleMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMonitorCard(
                      AppStrings.kelembapan,
                      "${humidity.toStringAsFixed(1)}%",
                      AppColors.primaryGreen,
                      Icons.water_drop),
                  _buildMonitorCard(
                      AppStrings.suhu,
                      "${tempDHT.toStringAsFixed(1)}°C",
                      Colors.orange,
                      Icons.thermostat),
                  _buildMonitorCard(
                      "Suhu Air",
                      "${tempDS.toStringAsFixed(1)}°C",
                      Colors.blue,
                      Icons.thermostat_outlined),
                ],
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(AppStrings.blynkData,
                    style: TextStyle(fontSize: 12, color: AppColors.primary)),
              ),

              const SizedBox(height: 24),

              // Prediksi Panen
              Text(AppStrings.prediksiPanen,
                  style:
                      textStyle.titleMedium), // Used AppStrings.prediksiPanen
              const SizedBox(height: 8),
              ...predictions.map((item) => PanenPredictionItem(item: item)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context,
                AppStrings.monitoringRoute); // Used AppStrings.monitoringRoute
          }
          if (index == 2)
            Navigator.pushReplacementNamed(
                context, AppStrings.panenRoute); // Used AppStrings.panenRoute
        },
      ),
    );
  }

  Widget _buildMonitorCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: AppColors.buttonTextWhite,
              size: 20), // Used AppColors.buttonTextWhite
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color:
                  AppColors.buttonTextWhite, // Used AppColors.buttonTextWhite
              fontWeight: FontWeight.bold,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color:
                  AppColors.buttonTextWhite, // Used AppColors.buttonTextWhite
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
