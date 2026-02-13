import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/exceptions/exceptions.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/app_controllers/client_controller.dart';
import '/ui/home/clients_page.dart';
import '/ui/home/register_client_screen.dart';
import '/ui/utils/loader.dart';
import '/ui/utils/navigate_to_root.dart';
import '../app_components/custom_drawer_widget.dart';
import '../app_components/dialog_information.dart';
import '../app_controllers/user_controller.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AppMessages, Loader, NavigateTo {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePageWidget(),
    const RegisterClientScreen(showAppBar: false),
    const ClientsPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  Future<void> _getUserData() async {
    var ctrl = context.read<UserController>();
    try {
      showLoader();
      await ctrl.getUserData().whenComplete(() {
        hideLoader();
      });
    } on TokenException {
      _expiredSessionDialog();
    } catch (e) {
      showCustomDialog(
        children: [
          DialogInformationWidget(message: e.toString(), title: "Beltran"),
        ],
      );
    }
  }

  Future<void> _getClientsData() async {
    var ctrl = context.read<ClientController>();
    try {
      await ctrl.getClients();
    } on TokenException {
      _expiredSessionDialog();
    } catch (e) {
      log(e.toString());
    }
  }

  void _expiredSessionDialog() {
    showCustomDialog(
      children: [
        DialogInformationWidget(
          message: "Sua sessão expirou, por favor faça login novamente",
          title: "Beltran",
        ),
      ],
    ).then((_) {
      navigateTo("/auth_login");
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([_getUserData(), _getClientsData()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.primaryColor,
        foregroundColor: Colors.white,
      ),

      drawer: const CustomDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        iconSize: 26,
        elevation: 20,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "Adicionar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_outlined),
            label: "Clientes",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      body: _pages.elementAt(_selectedIndex),
    );
  }
}
