import 'dart:convert';
import 'package:Retail_Application/models/dashboard/customer_model.dart';
import 'package:Retail_Application/ui/components/apz_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:go_router/go_router.dart';
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
  final IconData? editIcon; // 👈 new parameter

  const ProfileAvatarWidget({
    super.key,
    required this.name,
    required this.imageAsset,
    this.avatarRadius = 48,
    this.showEditIcon = false,
    this.onEdit,
    this.editIcon,
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
                        widget.editIcon, // 👈 now dynamic
                        size: 20,
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
                onPressed: () {
                  context.push('/login');
                },
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

  Widget _buildInfoContainer(List<Map<String, String>> infoList) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppColors.container_box(context),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x7FD7E2ED)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1E636363),
            blurRadius: 8,
            offset: Offset(0, 2.5),
          ),
        ],
      ),
      child: Column(
        children: infoList
            .map((info) => ProfileInfoTile(
                  label: info["label"]!,
                  value: info["value"]!,
                ))
            .toList(),
      ),
    );
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
              final date = DateTime.parse(dob);
              return DateFormat("dd MMM yyyy").format(date);
            } catch (e) {
              return dob;
            }
          }

          // Separate two groups of info
          final addressInfo = [
            {"label": "Permanent Address", "value": customer.permAddress},
            {
              "label": "Communication Address",
              "value": customer.communicationAddress
            },
          ];

          final generalInfo = [
            {"label": "Customer ID", "value": customer.customerId},
            {
              "label": "Date of Birth",
              "value": formatDate(customer.dateOfBirth)
            },
            {"label": "Username", "value": customer.customerName},
            {"label": "Mobile Number", "value": customer.mobileNo},
            {"label": "Email ID", "value": customer.emailId},
            {"label": "Type", "value": customer.customerType},
          ];

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeaderWidget(
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                    onActionPressed: () {
                      ApzAlert.show(
                        context,
                        title: "Coming Soon",
                        message: "This feature is under development.",
                        messageType: ApzAlertMessageType.info,
                        buttons: ["OK"],
                      );
                    },
                    trailingIcon: Icons.edit,
                    title: "Profile",
                  ),
                  ProfileAvatarWidget(
                    name: customer.customerName,
                    imageAsset: "assets/images/Person.png",
                    showEditIcon: true,
                    editIcon: Icons.qr_code,
                  ),

                  // 👉 First container: Address
                  _buildInfoContainer(generalInfo),

                  // 👉 Second container: Other details
                  _buildInfoContainer(addressInfo),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
