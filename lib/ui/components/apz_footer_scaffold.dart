// import 'package:Retail_Application/models/menu_model/apz_menu_options.dart';
// import 'package:Retail_Application/ui/components/apz_footer.dart';
// import 'package:Retail_Application/ui/widgets/menu_screen.dart';
// import 'package:flutter/material.dart';

// class ApzFooterScaffold extends StatefulWidget {
//   final Widget body;
//   final List<MenuOptionModel> menuOptions;
//   final int selectedIndex;
//   final ValueChanged<int> onItemSelected;

//   const ApzFooterScaffold({
//     Key? key,
//     required this.body,
//     required this.menuOptions,
//     required this.selectedIndex,
//     required this.onItemSelected,
//   }) : super(key: key);

//   @override
//   _ApzFooterScaffoldState createState() => _ApzFooterScaffoldState();
// }

// class _ApzFooterScaffoldState extends State<ApzFooterScaffold> {
//   bool _isMenuOpen = false;

//   void _toggleMenu(BuildContext context) {
//     if (_isMenuOpen) {
//       Navigator.pop(context);
//       // The `whenComplete` will handle setting _isMenuOpen to false
//     } else {
//       setState(() {
//         _isMenuOpen = true;
//       });
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         builder: (BuildContext context) {
//           return MenuSheet(options: widget.menuOptions);
//         },
//       ).whenComplete(() {
//         if (mounted) {
//           setState(() {
//             _isMenuOpen = false;
//           });
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.body,
//       bottomNavigationBar: FooterBar(
//         selectedIndex: widget.selectedIndex,
//         onItemSelected: (index) {
//           if (index == 2) { // Center button index
//             _toggleMenu(context);
//           } else {
//             widget.onItemSelected(index);
//           }
//         },
//         isMenuOpen: _isMenuOpen, onCenterTap: () {  },
//       ),
//     );
//   }
// }