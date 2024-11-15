import 'package:flutter/material.dart';
import 'package:grow_buddy/features/price_prediction_screen/price_prediction_screen.dart';

class CropsScreen extends StatefulWidget {
  static const String routeName = "/crop-selection-screen";
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  final List<Map<String, String>> crops = [
    {"image": "assets/images/corn.png", "text": "Maize"},
    {"image": "assets/images/nature.png", "text": "Cotton"},
    {"image": "assets/images/sugar-cane.png", "text": "SugarCane"},
    {"image": "assets/images/wheat-plant.png", "text": "Wheat"},
    {"image": "assets/images/wheat.png", "text": "Bajra"},
    {"image": "assets/images/sorghum.png", "text": "Jowar"},
  ];
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crops"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: crops.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PricePredictionScreen.routeName,
                  arguments: crops[index]["text"],
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          crops[index]["image"] ?? "",
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        crops[index]["text"] ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
