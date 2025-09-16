import 'dart:convert';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_alert.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Retail_Application/models/dashboard/favourite_transaction_model.dart';

class FavoriteTransactionsRow extends StatefulWidget {
  const FavoriteTransactionsRow({super.key});

  @override
  State<FavoriteTransactionsRow> createState() =>
      _FavoriteTransactionsRowState();
}

class _FavoriteTransactionsRowState extends State<FavoriteTransactionsRow> {
  late Future<List<FavoriteTransaction>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = loadFavorites();
  }

  Future<List<FavoriteTransaction>> loadFavorites() async {
    final String response =
        await rootBundle.loadString('mock/Dashboard/favourite_mock.json');
    final Map<String, dynamic> data = json.decode(response);

    final List<dynamic> favoritesJson = data['APZRMB__FavoriteTransactions_Res']
        ['apiResponse']['ResponseBody']['responseObj']['favoriteTransactions'];

    return favoritesJson
        .map((json) => FavoriteTransaction.fromJson(json))
        .toList();
  }

  Color _getBgColor(int index) {
    const colors = [
      Color(0xFF97E5F6),
      Color(0xFFD594EC),
      Color(0xFFFF9FC1),
      Color(0xFFB3E0FF),
    ];
    return colors[index % colors.length];
  }

  void _onFavoriteTap(FavoriteTransaction fav) {
    ApzAlert.show(
      context,
      title: "Coming Soon",
      message: "This feature is under development.",
      messageType: ApzAlertMessageType.info,
      buttons: ["OK"],
      onButtonPressed: (btn) {
        // Optional: handle button tap
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FavoriteTransaction>>(
      future: _favoritesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("Error loading favorites")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("No favorites found")),
          );
        }

        final favorites = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24), // spacing above
            ApzText(
              label: "Favourite Transactions",
              color: AppColors.favouriteHeader(context),
              fontSize: 14,
              fontWeight: ApzFontWeight.titlesRegular,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(width: 30),
                itemBuilder: (context, index) {
                  final fav = favorites[index];
                  final hasImage = fav.imageUrl != null;

                  return InkWell(
                    onTap: () => _onFavoriteTap(fav),
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      width: 54,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.favouriteBoxShadow(context),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: hasImage
                                  ? Colors.transparent
                                  : _getBgColor(index),
                              backgroundImage:
                                  hasImage ? AssetImage(fav.imageUrl!) : null,
                              child: hasImage
                                  ? null
                                  : ApzText(
                                      label: fav.name.isNotEmpty
                                          ? fav.name[0].toUpperCase()
                                          : '',
                                      color: AppColors.favouriteText(context),
                                      fontSize: 20.8,
                                      fontWeight: ApzFontWeight.titlesRegular,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 52,
                            child: Center(
                              child: ApzText(
                                label: fav.name,
                                color: AppColors.primary_text(context),
                                fontSize: 12,
                                fontWeight: ApzFontWeight.titlesMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24), // spacing below
            Opacity(
              opacity: 0.8,
              child: Divider(
                thickness: 0.3,
                color: AppColors.upcomingPaymentsDivider(context),
                height: 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
