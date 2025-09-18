import 'dart:convert';
import 'package:Retail_Application/models/dashboard/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';

/// ✅ Load Customer Mock Data
Future<CustomerModel> loadCustomerData() async {
  final String response =
      await rootBundle.loadString('mock/Dashboard/account_mock.json');
  final Map<String, dynamic> data = json.decode(response);

  final customerJson =
      data['apiResponse']['ResponseBody']['responseObj']['customerDetails'];
  return CustomerModel.fromJson(customerJson);
}

/// ✅ Custom Header Widget (Stateful)

class ProfileHeaderWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onActionPressed;
  final IconData? trailingIcon;

  const ProfileHeaderWidget({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onActionPressed,
    this.trailingIcon,
  });

  @override
  _ProfileHeaderWidgetState createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  Widget _profileHeaderIcon({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.profileHeaderIconBg(context),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                AppColors.profileHeaderIconGradient1(context),
                AppColors.profileHeaderIconGradient2(context),
                AppColors.profileHeaderIconGradient3(context),
                AppColors.profileHeaderIconGradient4(context),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10), // 10% opacity
              offset: Offset(0, 2), // X:0, Y:2
              blurRadius: 2, // Blur: 4
              spreadRadius: 0, // Spread: 0
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: AppColors.primary_text(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _profileHeaderIcon(
              icon: Icons.arrow_back_ios_new,
              onTap: widget.onBackPressed,
            ),
            Expanded(
              child: Center(
                child: ApzText(
                  label: widget.title,
                  color: AppColors.primary_text(context),
                  fontSize: 16,
                  fontWeight: ApzFontWeight.headingsBold,
                ),
              ),
            ),
            widget.trailingIcon != null
                ? _profileHeaderIcon(
                    icon: widget.trailingIcon!,
                    onTap: widget.onActionPressed,
                  )
                : SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}

/// ✅ Stateful Profile Avatar with Name Widget using CircleAvatar
class ProfileAvatarWidget extends StatefulWidget {
  final String name;
  final String imageAsset;
  final double avatarRadius;
  final bool showEditIcon;
  final VoidCallback? onEdit;

  const ProfileAvatarWidget({
    super.key,
    required this.name,
    required this.imageAsset,
    this.avatarRadius = 48,
    this.showEditIcon = false,
    this.onEdit,
  });

  @override
  _ProfileAvatarWidgetState createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: widget.avatarRadius,
                backgroundColor: AppColors.input_field_filled(context),
                backgroundImage: AssetImage(widget.imageAsset),
              ),
              if (widget.showEditIcon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onEdit,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.inverse_text(context),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                        color: AppColors.primary_text(context),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: Center(
              child: ApzText(
                label: widget.name,
                color: AppColors.primary_text(context),
                fontSize: 16,
                fontWeight: ApzFontWeight.headingsBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ A stateful row-style tile to display label + value
class ProfileInfoTile extends StatefulWidget {
  final String label;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  State<ProfileInfoTile> createState() => _ProfileInfoTileState();
}

class _ProfileInfoTileState extends State<ProfileInfoTile> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApzText(
                  label: widget.label,
                  color: AppColors.tertiary_text(context),
                  fontSize: 12,
                  fontWeight: ApzFontWeight.labelRegular,
                ),
                ApzText(
                  label: widget.value,
                  color: AppColors.primary_text(context),
                  fontSize: 14,
                  fontWeight: ApzFontWeight.buttonTextMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFooterWidget extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfileFooterWidget({
    super.key,
    this.onLogout,
  });

  @override
  State<ProfileFooterWidget> createState() => _ProfileFooterWidgetState();
}

class _ProfileFooterWidgetState extends State<ProfileFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.profileFooterBg(context), // Theme-bg-2
        boxShadow: [
          BoxShadow(
            color: AppColors.profileFooterShadow(context),
            blurRadius: 8,
            offset: Offset(0, -3),
            spreadRadius: 0,
          )
        ],
      ),
      child: GestureDetector(
        onTap: widget.onLogout,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ApzButton(
                label: "LOG OUT",
                appearance: ApzButtonAppearance.tertiary,
                size: ApzButtonSize.large,
                iconTrailing: Icons.logout,
                textColor: AppColors.profileFooterButton(context),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ Profile Screen (Stateful)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<CustomerModel> _customerFuture;

  @override
  void initState() {
    super.initState();
    _customerFuture = loadCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ProfileFooterWidget(
        onLogout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out")),
          );
        },
      ),
      body: FutureBuilder<CustomerModel>(
        future: _customerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No Data Found"));
          }

          final customer = snapshot.data!;
          String formatDate(String dob) {
            try {
              final date = DateTime.parse(dob); // parses "1994-09-01"
              return DateFormat("dd MMM yyyy").format(date); // "01 Sep 1994"
            } catch (e) {
              return dob;
            }
          }

          final profileInfo = [
            {"label": "Customer ID", "value": customer.customerId},
            {
              "label": "Date of Birth",
              "value": formatDate(customer.dateOfBirth)
            },
            {"label": "Username", "value": customer.customerName},
            {"label": "Mobile Number", "value": customer.mobileNo},
            {"label": "Email ID", "value": customer.emailId},
            {"label": "Type", "value": customer.customerType},
            {"label": "Permanent Address", "value": customer.permAddress},
            {
              "label": "Communication Address",
              "value": customer.communicationAddress
            },
          ];

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  onActionPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Action tapped")),
                    );
                  },
                  trailingIcon: Icons.edit,
                  title: "Profile",
                ),
                ProfileAvatarWidget(
                  name: customer.customerName,
                  imageAsset: "assets/mock/person.png",
                ),
                ...profileInfo.map((info) {
                  if (info["label"] == "Permanent Address") {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16), // adjust padding
                          child: Divider(
                            thickness: 0.3,
                            color: AppColors.upcomingPaymentsDivider(context)
                              ..withOpacity(0.8), // matches your theme
                          ),
                        ),
                        ProfileInfoTile(
                          label: info["label"]!,
                          value: info["value"]!,
                        ),
                      ],
                    );
                  } else {
                    return ProfileInfoTile(
                      label: info["label"]!,
                      value: info["value"]!,
                    );
                  }
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
