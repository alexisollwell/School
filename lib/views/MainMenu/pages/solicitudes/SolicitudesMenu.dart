import 'package:flutter/material.dart';
import 'package:school/views/MainMenu/pages/solicitudes/solicitudes.dart';
import 'package:school/views/MainMenu/pages/solicitudes/solicitudesListado.dart';

import '../../../../constants.dart';

class SolicitudesMenu extends StatefulWidget {
  const SolicitudesMenu({super.key});

  @override
  State<SolicitudesMenu> createState() => _SolicitudesMenuState();
}

class _SolicitudesMenuState extends State<SolicitudesMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeToList() {
    _tabController.animateTo(0);
  }

  void changeToAdd() {
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solicitudes",
          style: TextStyle(
              color: orange2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list)),
            Tab(icon: Icon(Icons.add)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SolicitudesListado(
            onAdd: changeToAdd,
          ),
          Solicitudes(
            goList: changeToList,
          ),
        ],
      ),
    );
  }
}
