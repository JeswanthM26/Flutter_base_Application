import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:retail_application/models/dashboard/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retail_application/pluginIntegration/profile_provider.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/themes/apz_theme_provider.dart';
import 'package:retail_application/ui/components/apz_button.dart';
import 'package:retail_application/ui/components/apz_text.dart';
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
  final IconData? editIcon; // 👈 new parameter
  final File? imageFile;

  final VoidCallback? onAvatarTap; // optional avatar tap
  final VoidCallback? onEdit; // QR tap

  const ProfileAvatarWidget({
    super.key,
    required this.name,
    required this.imageAsset,
    this.avatarRadius = 48,
    this.showEditIcon = false,
    this.editIcon,
    this.onAvatarTap,
    this.onEdit,
    this.imageFile,
  });

  @override
  _ProfileAvatarWidgetState createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: widget.onAvatarTap,
                child: CircleAvatar(
                  radius: widget.avatarRadius,
                  backgroundColor: AppColors.input_field_filled(context),
                  // backgroundImage: AssetImage(widget.imageAsset),
                  backgroundImage: widget.imageFile != null
                      ? FileImage(widget.imageFile!)
                      : AssetImage(widget.imageAsset) as ImageProvider<Object>?,
                ),
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
                        widget.editIcon,
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
            // Wrap the Column in Expanded so it can take available space
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzText(
                    label: widget.label,
                    color: AppColors.tertiary_text(context),
                    fontSize: 12,
                    fontWeight: ApzFontWeight.labelRegular,
                  ),
                  const SizedBox(height: 4), // small spacing
                  ApzText(
                    label: widget.value,
                    color: AppColors.primary_text(context),
                    fontSize: 14,
                    fontWeight: ApzFontWeight.buttonTextMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFooterWidget extends StatefulWidget {
  final String label;
  final IconData? trailingIcon;
  final Color? textColor;
  final ApzButtonAppearance appearance;
  final VoidCallback? onPressed;

  const ProfileFooterWidget({
    super.key,
    required this.label,
    this.trailingIcon,
    this.textColor,
    this.appearance = ApzButtonAppearance.tertiary,
    this.onPressed,
  });

  @override
  State<ProfileFooterWidget> createState() => _ProfileFooterWidgetState();
}

class _ProfileFooterWidgetState extends State<ProfileFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // <-- wrap here
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.profileFooterBg(context),
          boxShadow: [
            BoxShadow(
              color: AppColors.profileFooterShadow(context),
              blurRadius: 8,
              offset: const Offset(0, -3),
              spreadRadius: 0,
            )
          ],
        ),
        child: GestureDetector(
          onTap: widget.onPressed,
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
                  label: widget.label,
                  appearance: widget.appearance,
                  size: ApzButtonSize.large,
                  iconTrailing: widget.trailingIcon,
                  textColor: widget.textColor,
                  onPressed: widget.onPressed,
                ),
              ],
            ),
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

  bool _isCustomerIdVisible = false;
  String maskCustomerId(String id, bool isVisible) {
    if (isVisible) return id;
    if (id.isEmpty) return '';

    if (id.length <= 2) {
      // too short → mask all but first char
      return id[0] + 'X' * (id.length - 1);
    }

    String first = id.substring(0, 1);
    String last = id.substring(id.length - 3 > 0 ? id.length - 3 : 1);
    int maskCount = id.length - (first.length + last.length);

    return "$first${'X' * maskCount}$last";
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

  int _currentPage = 0;

  void _showImageCarousel(
      {int initialPage = 0,
      // required String profileImageAsset,
      required String qrImageAsset,
      required ImageProvider profileImageProvider}) {
    setState(() {
      _currentPage = initialPage;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.88, // spacing between dialogs
    );

    List<Widget> pages = [
      // Profile Image Dialog
      Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: AppColors.profileDialogContainer(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.45,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: profileImageProvider,
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(16),
                    // side: BorderSide(
                    //   width: 1, color: AppColors.profileDialogBorder(context)),
                    ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E636363),
                    blurRadius: 8,
                    offset: Offset(0, 2.5),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // QR Code Dialog
      Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: AppColors.profileDialogContainer(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth * 0.75,
              height: screenWidth * 0.75,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(qrImageAsset),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 1,
                    color: AppColors.profileDialogBorder(context),
                  ),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x1E636363),
                    blurRadius: 8,
                    offset: Offset(0, 2.5),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Share QR functionality
                    },
                    child: Container(
                      height: screenWidth * 0.20,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share,
                              color: AppColors.primary_text(context), size: 24),
                          SizedBox(height: 12),
                          ApzText(
                            label: 'SHARE',
                            color: AppColors.primary_text(context),
                            fontSize: 15,
                            fontWeight: ApzFontWeight.titlesMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Download QR functionality
                    },
                    child: Container(
                      height: screenWidth * 0.20,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download,
                              color: AppColors.primary_text(context), size: 24),
                          SizedBox(height: 12),
                          ApzText(
                            label: 'DOWNLOAD',
                            color: AppColors.primary_text(context),
                            fontSize: 15,
                            fontWeight: ApzFontWeight.titlesMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: StatefulBuilder(
          builder: (context, setState) {
            // this setState updates the dialog
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenHeight * 0.49,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index; // updates text + dots
                      });
                    },
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: pages[index],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary_text(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ApzText(
                        label: "${_currentPage + 1}/${pages.length}",
                        color: AppColors.inverse_text(context),
                        fontSize: 11,
                        fontWeight: ApzFontWeight.titlesMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: List.generate(pages.length, (dotIndex) {
                        return GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              dotIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == dotIndex
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final profileProvider = Provider.of<ProfileProvider>(context);
    // final profileImagePath = profileProvider.profileImagePath;

    return Scaffold(
      bottomNavigationBar: ProfileFooterWidget(
        label: "LOG OUT",
        trailingIcon: Icons.logout,
        textColor: AppColors.profileFooterButton(context),
        onPressed: () {
          context.go('/login');
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
            child: Column(
              children: [
                // ✅ Sticky Header
                ProfileHeaderWidget(
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                  onActionPressed: () {
                    context.push<String?>(
                      '/edit',
                      extra: customer,
                    );
                  },
                  trailingIcon: Icons.edit,
                  title: "Profile",
                ),

                // ✅ Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Consumer<ProfileProvider>(
                          builder: (context, profileProvider, child) {
                            final profileImagePath =
                                profileProvider.profileImagePath;
                            return ProfileAvatarWidget(
                              name: customer.customerName,
                              imageAsset: "assets/images/Person.png",
                              imageFile: profileImagePath != null
                                  ? File(profileImagePath)
                                  : null,
                              // ProfileAvatarWidget(
                              //   name: customer.customerName,
                              //   imageAsset: "assets/images/Person.png",
                              //   imageFile: profileImagePath != null
                              //       ? File(profileImagePath!)
                              //       : null,
                              showEditIcon: true,
                              editIcon: Icons.qr_code,
                              onAvatarTap: () {
                                final imageProvider = profileImagePath != null
                                    ? FileImage(File(profileImagePath))
                                    : const AssetImage(
                                        "assets/images/Person.png");
                                _showImageCarousel(
                                  initialPage: 0,
                                  profileImageProvider:
                                      imageProvider as ImageProvider,
                                  qrImageAsset: "assets/images/qr.jpg",
                                );
                              },
                              onEdit: () {
                                final imageProvider = profileImagePath != null
                                    ? FileImage(File(profileImagePath))
                                    : const AssetImage(
                                        "assets/images/Person.png");
                                _showImageCarousel(
                                  initialPage: 1,
                                  profileImageProvider:
                                      imageProvider as ImageProvider,
                                  qrImageAsset: "assets/images/qr.jpg",
                                );
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ApzText(
                                label:
                                    "Customer ID: ${maskCustomerId(customer.customerId, _isCustomerIdVisible)}",
                                color: AppColors.tertiary_text(context),
                                fontSize: 14,
                                fontWeight: ApzFontWeight.buttonTextMedium,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isCustomerIdVisible =
                                        !_isCustomerIdVisible;
                                  });
                                },
                                child: Icon(
                                  _isCustomerIdVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 18,
                                  color: AppColors.tertiary_text(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildInfoContainer(generalInfo),
                        _buildInfoContainer(addressInfo),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ApzText(
                                    label: "Theme",
                                    fontSize: 16,
                                    fontWeight: ApzFontWeight.titlesMedium,
                                    color: AppColors.primary_text(context),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Icons.dark_mode
                                            : Icons.light_mode,
                                        color: AppColors.primary_text(context),
                                      ),
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: themeProvider.themeMode ==
                                            ThemeMode.dark,
                                        onChanged: (value) {
                                          themeProvider.toggleTheme();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
