import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;
    return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_, int index) {
          return ListTile(
            leading: Icon(
              Icons.map,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(scans[index].valor),
            subtitle: Text(scans[index].id.toString()),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
            onTap: () {
              print(scans[index].id);
            },
          );
        });
  }
}
