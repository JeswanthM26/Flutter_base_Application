import 'dart:io';

import 'package:provider/provider.dart';
import 'package:retail_application/models/dashboard/customer_model.dart';
import 'package:retail_application/pluginIntegration/apz_media_picker.dart';
import 'package:retail_application/pluginIntegration/profile_provider.dart';
import 'package:retail_application/ui/components/apz_input_with_dropdown.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_input_field.dart';

import 'profile_screen.dart'; // 👈 Import your header + avatar widgets

class EditScreen extends StatefulWidget {
  final CustomerModel
      customer; // ✅ Use CustomerModel instead of individual fields

  const EditScreen({super.key, required this.customer});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _customerIdController;
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _typeController;
  late final TextEditingController _pAddressController;
  late final TextEditingController _cAddressController;
  final ApzMediaPicker _mediaPicker = ApzMediaPicker();
  // String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _customerIdController =
        TextEditingController(text: widget.customer.customerId);
    _nameController = TextEditingController(text: widget.customer.customerName);
    _dobController = TextEditingController(text: widget.customer.dateOfBirth);
    _mobileController = TextEditingController(text: widget.customer.mobileNo);
    _emailController = TextEditingController(text: widget.customer.emailId);
    _typeController = TextEditingController(text: widget.customer.customerType);
    _pAddressController =
        TextEditingController(text: widget.customer.permAddress);
    _cAddressController =
        TextEditingController(text: widget.customer.communicationAddress);
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _typeController.dispose();
    _pAddressController.dispose();
    _cAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profileImagePath = profileProvider.profileImagePath;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// ✅ Profile Header
              ProfileHeaderWidget(
                title: "Edit Profile",
                onBackPressed: () => context.pop(),
              ),

              /// ✅ Profile Avatar
              ProfileAvatarWidget(
                name: _nameController.text,
                imageAsset: "assets/images/Person.png",
                imageFile:
                    profileImagePath != null ? File(profileImagePath!) : null,
                showEditIcon: true,
                editIcon: Icons.camera_alt,
                onAvatarTap: () {},
                onEdit: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => _buildEditProfileBottomSheet(context),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// ✅ Editable Fields
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Customer ID",
                  controller: _customerIdController,
                  hintText: "Enter Customer ID",
                  isMandatory: false,
                  enabled: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "DOB",
                  controller: _dobController,
                  hintText: "Enter your DOB",
                  isMandatory: false,
                  enabled: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Full Name",
                  controller: _nameController,
                  hintText: "Enter your full name",
                  isMandatory: false,
                  enabled: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputWithDropdown(
                  phoneController: _mobileController,
                  label: "Mobile Number",
                  hintText: "Enter your phone number",
                  isMandatory: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Email",
                  controller: _emailController,
                  hintText: "Enter your email",
                  isEmailFld: true,
                  isMandatory: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Type",
                  controller: _typeController,
                  hintText: "Enter your account type",
                  isMandatory: false,
                  enabled: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Permanent Address",
                  controller: _pAddressController,
                  hintText: "Enter your Permanent address",
                  isMandatory: false,
                  enabled: false,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ApzInputField(
                  label: "Communication address",
                  controller: _cAddressController,
                  hintText: "Enter your Communication address",
                  isMandatory: false,
                  enabled: true,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      /// ✅ Footer instead of SAVE CHANGES button
      bottomNavigationBar: ProfileFooterWidget(
        label: "UPDATE CHANGES",
        textColor: AppColors.tertiary_button_default(context),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile Updated")),
          );
          context.pop();
        },
      ),
    );
  }

  // ========================= Bottom Sheet =========================

  Widget _buildEditProfileBottomSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, left: 1),
      decoration: ShapeDecoration(
        color: AppColors.profileDialogContainer(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      child: SafeArea(
        top: false, // ✅ avoids extra padding at the top, keeps bottom safe
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grab bar
            Container(
              width: 36,
              height: 5,
              margin: const EdgeInsets.only(top: 6, bottom: 16),
              decoration: ShapeDecoration(
                color: const Color(0x7FC2C2C2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: ApzText(
                  label: 'Edit Profile',
                  color: AppColors.primary_text(context),
                  fontSize: 16,
                  fontWeight: ApzFontWeight.headingsBold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // === Camera & Image grouped ===
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: ShapeDecoration(
                color: AppColors.container_box(context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.profileDialogBorder(context),
                  ),
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
                children: [
                  _buildBottomSheetOption(
                    context,
                    label: "Camera", icon: Icons.camera_alt_outlined,
                    // onTap: () {
                    //   Navigator.pop(context);
                    // },
                    onTap: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      final pickedPath =
                          await _mediaPicker.pickImageFromCamera(context);
                      if (pickedPath != null) {
                        context
                            .read<ProfileProvider>()
                            .updateProfileImagePath(pickedPath);
                      }
                    },
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: AppColors.upcomingPaymentsDivider(context),
                        height: 0,
                        thickness: 1,
                      ),
                    ),
                  ),
                  _buildBottomSheetOption(
                    context,
                    label: "Image",
                    icon: Icons.image_outlined,
                    // onTap: () {
                    //   Navigator.pop(context);
                    onTap: () async {
                      Navigator.pop(context); // Close the bottom sheet
                      final pickedPath =
                          await _mediaPicker.pickImageFromGallery(context);
                      if (pickedPath != null) {
                        context
                            .read<ProfileProvider>()
                            .updateProfileImagePath(pickedPath);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // === Remove inside its own container ===
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: ShapeDecoration(
                color: AppColors.container_box(context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.profileDialogBorder(context),
                  ),
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
              child: _buildBottomSheetOption(
                context,
                label: "Remove",
                labelColor: AppColors.profileFooterButton(context),
                icon: Icons.delete_outline,
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileProvider>().updateProfileImagePath(null);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    Color? labelColor,
    VoidCallback? onTap,
  }) {
    final effectiveColor = labelColor ?? AppColors.primary_text(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ApzText(
              label: label,
              color: effectiveColor,
              fontSize: 12,
              fontWeight: ApzFontWeight.titlesSemibold,
            ),
            Icon(icon, size: 20, color: labelColor),
          ],
        ),
      ),
    );
  }
}
