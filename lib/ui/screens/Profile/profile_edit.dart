import 'package:Retail_Application/models/dashboard/customer_model.dart';
import 'package:Retail_Application/ui/components/apz_input_with_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_input_field.dart';

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
      decoration: const ShapeDecoration(
        color: Color(0xFFFFFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
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
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF181818),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.03,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Camera Option
          _buildBottomSheetOption(
            context,
            label: "Camera",
            onTap: () {
              // TODO: Add camera functionality
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),

          // Image Option
          _buildBottomSheetOption(
            context,
            label: "Image",
            onTap: () {
              // TODO: Add image picker functionality
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),

          // Remove Option
          _buildBottomSheetOption(
            context,
            label: "Remove",
            labelColor: const Color(0xFFF04248),
            onTap: () {
              // TODO: Add remove functionality
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context, {
    required String label,
    Color labelColor = const Color(0xFF1C1C1C),
    VoidCallback? onTap,
  }) {
    return Container(
      width: 343,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x7FD7E2ED),
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
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(
                width: 24), // Placeholder for trailing icon if needed
          ],
        ),
      ),
    );
  }
}
