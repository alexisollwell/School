import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/constants.dart';
import 'package:school/views/MainMenu/pages/campus/campus.dart';
import 'package:school/views/MainMenu/pages/carreras/carreras.dart';
import 'package:school/views/MainMenu/pages/divisiones/divisiones.dart';
import 'package:school/views/MainMenu/pages/perfil/perfil.dart';
import 'package:school/views/MainMenu/pages/periodos/periodos.dart';
import 'package:school/views/MainMenu/pages/personas/personas.dart';
import 'package:school/views/MainMenu/pages/pruebas/pruebas.dart';
import 'package:school/views/MainMenu/pages/reportes/reportes.dart';
import 'package:school/views/MainMenu/pages/solicitudes/SolicitudesMenu.dart';
import 'package:school/views/MainMenu/pages/userTest/userPendingtest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/decisionDialogAlert.dart';
import '../../custom_libraries/SideNavigation/src/api/side_navigation_bar.dart';
import '../../custom_libraries/SideNavigation/src/api/side_navigation_bar_header.dart';
import '../../custom_libraries/SideNavigation/src/api/side_navigation_bar_item.dart';
import '../../custom_libraries/SideNavigation/src/api/side_navigation_bar_theme.dart';
import '../access/login/login.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late bool _isExpanded;
  late int selectedIndex;
  final GlobalKey<State<SideNavigationBar>> _myKeyMenu = GlobalKey();

  void toggle() {
    final openTicketsState = _myKeyMenu.currentState as SideNavigationBarState?;
    openTicketsState?.toggle();
  }

  void showExpandedMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> closeSession() async {
    bool response = await showDecisionAlert(
            title: "Atención",
            message: "¿Estas seguro de cerrar tu sesión?",
            context: context) ??
        false;
    if (response) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('password');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  Widget views(index) {
    if (userType == 1) {
      switch (index) {
        case 0:
          return const Campus();
        case 1:
          return const Periodos();
        case 2:
          return const Divisiones();
        case 3:
          return const Carreras();
        case 4:
          return const Perfil();
        case 5:
          return const Pruebas();
        case 6:
          return const Personas();
        case 7:
          return const SolicitudesMenu();
        case 8:
          return const Reportes();
        default:
          return Container();
      }
    } else if (userType == 2 || userType == 4) {
      switch (index) {
        case 0:
          return const Periodos();
        case 1:
          return const Carreras();
        case 2:
          return const Perfil();
        case 3:
          return const Pruebas();
        case 4:
          return const SolicitudesMenu();
        case 5:
          return const Reportes();
        default:
          return Container();
      }
    } else {
      return const UserPendingTest();
    }
  }

  List<SideNavigationBarItem> menuItems() {
    if (userType == 1) {
      return [
        const SideNavigationBarItem(
          icon: Icons.location_city,
          label: 'Campus',
        ),
        const SideNavigationBarItem(
          icon: Icons.date_range,
          label: 'Periodos',
        ),
        const SideNavigationBarItem(
          icon: Icons.group_work,
          label: 'Divisiones',
        ),
        const SideNavigationBarItem(
          icon: Icons.diversity_3,
          label: 'Carreras',
        ),
        const SideNavigationBarItem(
          icon: Icons.account_circle,
          label: 'Perfil',
        ),
        const SideNavigationBarItem(
          icon: Icons.quiz,
          label: 'Pruebas',
        ),
        const SideNavigationBarItem(
          icon: Icons.ac_unit,
          label: 'Usuario',
        ),
        const SideNavigationBarItem(
          icon: Icons.edit_document,
          label: 'Solicitudes',
        ),
        const SideNavigationBarItem(
          icon: Icons.feed,
          label: 'Reportes',
        )
      ];
    } else if (userType == 2 || userType == 4) {
      return [
        const SideNavigationBarItem(
          icon: Icons.date_range,
          label: 'Periodos',
        ),
        const SideNavigationBarItem(
          icon: Icons.diversity_3,
          label: 'Carreras',
        ),
        const SideNavigationBarItem(
          icon: Icons.account_circle,
          label: 'Perfil',
        ),
        const SideNavigationBarItem(
          icon: Icons.quiz,
          label: 'Pruebas',
        ),
        const SideNavigationBarItem(
          icon: Icons.edit_document,
          label: 'Solicitudes',
        ),
        const SideNavigationBarItem(
          icon: Icons.feed,
          label: 'Reportes',
        )
      ];
    } else {
      return [
        const SideNavigationBarItem(
          icon: Icons.quiz,
          label: 'Pruebas',
        )
      ];
    }
  }

  void refreshPage(index) {
    /*switch(index){
      case 0:
        final openTicketsState = _myKeyOpenTickets.currentState as OpenTicketsState?;
        openTicketsState?.refreshData();
        break;
      case 1:
        final pendingTicketsState = _myKeyPendingTickets.currentState as PendingTicketsState?;
        pendingTicketsState?.refreshData();
        break;
      case 2:
        final rejectedTicketsState = _myKeyRejectedTickets.currentState as RejectedTicketsState?;
        rejectedTicketsState?.refreshData();
      default: print("");
    }*/
  }

  void setPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = true;
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                SideNavigationBar(
                  key: _myKeyMenu,
                  onExpanded: showExpandedMenu,
                  header: const SideNavigationBarHeader(
                      image: SizedBox(
                        width: 1,
                      ),
                      title: SizedBox(
                        width: 1,
                      ),
                      subtitle: SizedBox(
                        height: 70,
                        width: 180,
                      )),
                  selectedIndex: selectedIndex,
                  items: menuItems(),
                  itemBottom: SideNavigationBarItem(
                      icon: Icons.logout,
                      label: 'Cerrar sesión',
                      onTap: closeSession),
                  theme: SideNavigationBarTheme(
                    backgroundColor: Colors.white,
                    togglerTheme: SideNavigationBarTogglerTheme.standard(),
                    itemTheme: SideNavigationBarItemTheme.standard(),
                    dividerTheme: SideNavigationBarDividerTheme.standard(),
                  ),
                  onTap: (value) => setPage(value),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: views(selectedIndex),
                ))
              ],
            ),
            Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Image.asset(
                      "assets/images/xo.png",
                      fit: BoxFit.fitWidth,
                      width: 130,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: toggle,
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        loginPerson.nombre!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(loginPerson.correo!,
                          style: const TextStyle(
                              color: Colors.orange, fontSize: 14)),
                    ],
                  ),
                  /*userType == 3
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              loginPerson.nombre!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                  userType == 3
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("correo: ${loginPerson.correo}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text("teléfono: ${loginPerson.telefono}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  */
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
