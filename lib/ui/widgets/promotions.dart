import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Retail_Application/models/dashboard/promotions_model.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../themes/apz_app_themes.dart';

class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  List<Promotion> promotions = [];

  @override
  void initState() {
    super.initState();
    _loadPromotions();
  }

  Future<void> _loadPromotions() async {
    try {
      final String data =
          await rootBundle.loadString('mock/Dashboard/promotions_mock.json');
      final jsonResult = json.decode(data);
      final List list = jsonResult['apiResponse']['ResponseBody']['promotions'];
      setState(() {
        promotions = list.map((e) => Promotion.fromJson(e)).toList();
      });
    } catch (_) {
      setState(() {
        promotions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (promotions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: ApzText(
            label: "No promotions available",
            fontWeight: ApzFontWeight.bodyRegular,
            fontSize: 14,
            color: AppColors.tertiary_text(context),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ApzText(
            label: "Discover the product offers",
            fontWeight: ApzFontWeight.bodyRegular,
            color: AppColors.upcomingPaymentsHeader(context),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: promotions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final promo = promotions[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming Soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: promo.image1.isNotEmpty
                        ? DecorationImage(
                            image: AssetImage(promo.image1),
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 90),
                        ApzText(
                          label: promo.title,
                          fontWeight: ApzFontWeight.headingSemibold,
                          fontSize: 13,
                          color: AppColors.button_text_black(context),
                        ),
                        const SizedBox(height: 4),
                        ApzText(
                          label: promo.subtitle,
                          fontSize: 11,
                          fontWeight: ApzFontWeight.labelRegular,
                          color: const Color.fromARGB(255, 94, 94, 94),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
