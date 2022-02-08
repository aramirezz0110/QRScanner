import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/directions_page.dart';
import 'package:qr_reader/pages/maps_page.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(child: Text("History")),
        actions: [
          IconButton(
            onPressed: () {
              scanListProvider.borrarTodos();
            },
            icon: Icon(Icons.delete_forever_outlined),
          )
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //obtener el widget seleccionado
    final uiProvider = Provider.of<UIProvider>(context);
    //cambiar para mostrar la pagina
    final currentIndex = uiProvider.selectedMenuOpt;
    //para los datos de la db
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    //llamado a la base de datos
    DBProvider.db.database;
    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScanPorTipo('geo');
        return MapsPage();
      case 1:
        scanListProvider.cargarScanPorTipo('http');
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }
}
