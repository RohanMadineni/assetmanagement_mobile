import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../core/layout/main_layout.dart';
import '../../data/services/asset_service.dart';
import '../../../../core/network/api_client.dart';
class AssetListPage extends StatefulWidget{
  const AssetListPage({super.key});

  @override
  State<AssetListPage> createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  late final AssetService assetService;
  List<dynamic> assets = [];
  bool loadingAssets = true;
  @override
  void initState(){
        super.initState(); 
        assetService = AssetService(
            ApiClient(),
        );
        loadAssets();
    }
  void loadAssets() async {
    final result = await assetService.getAssets();
    setState(() {
      assets = List<dynamic>.from(result.data['data']);
      loadingAssets = false;
      if(loadingAssets==false)
        print(assets);
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 1,
      child: Scaffold(
        appBar: AppBar(title: const Text('Asset List')),
        body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height:6),
                    assetlisttable(),
                  ],
                ),    
              )
      )
    );
  }

  Widget assetlisttable(){
    if (loadingAssets) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Actions')),
        ],
        rows: assets.map((asset) {
          return DataRow(
            cells: [
              DataCell(
                Text(asset['id'].toString()),
              ),
              DataCell(
                Text(asset['name'] ?? ''),
              ),
              
              DataCell(
                Text(asset['status'] ?? ''),
              ),
              DataCell(
                Text(
                  asset['price']?.toString() ?? '0',
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const .all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Asset ${asset['id'].toString()}"),
                                Text("Name: ${asset['name']}"),
                                Text("Status: ${asset['status']}"),
                                Text("Brand: ${asset['brand']}"),
                                Text("Assiged To: ${asset['current_assignment']['user']['username']}"),
                                Text("Price: ${asset['price']}"),
                                Text("Warranty Expiration: ${asset['Warranty']}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.edit),
                    //   onPressed: () {
                    //     print(
                    //       'Edit ${asset['id']}',
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}