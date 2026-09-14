import 'package:flutter/material.dart';
import '../../../../core/layout/main_layout.dart';
import '../../data/services/asset_service.dart';
import '../../../../core/network/api_client.dart';
import '../../data/services/auth_service.dart';
import 'Widgets/asset-card.dart';
class AvailableAssetListPage extends StatefulWidget{
  const AvailableAssetListPage({super.key});

  @override
  State<AvailableAssetListPage> createState() => _AvailableAssetListPageState();
}

class _AvailableAssetListPageState extends State<AvailableAssetListPage> {
  late final AssetService assetService;
  late final AuthService authService;
  List<dynamic> assets = [];
  bool loadingAssets = true;
  String role = "";
  Map<String, dynamic>? user;
  @override
  void initState(){
        super.initState(); 
        assetService = AssetService(
            ApiClient(),
        );
        authService = AuthService(
          ApiClient(),
        );
        loadAssets();
    }
  Future<void> loadAssets() async {
    final result = await assetService.getAllAssets();
    final result2 = await authService.getRole(); 
    setState(() {
      assets = List<dynamic>.from(result.data['data']);
      user = result2.data;
      role = user!['role'][0].toUpperCase() + user!['role'].substring(1).toLowerCase();
      loadingAssets = false;
      if(loadingAssets==false) {
        print(assets);
      }
    });
    
  }
//   @override
//   Widget build(BuildContext context) {

//     if(role != 'Admin'){
//       return MainLayout(
//             selectedIndex: 0,
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//     }
//     return MainLayout(
//       selectedIndex: 3,
//       child: Scaffold(
//         appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Available Assets List')),
//         body: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const SizedBox(height:6),
//                     assetlisttable(),
//                   ],
//                 ),    
//               )
//       )
//     );
//   }

//   Widget assetlisttable(){
//     if (loadingAssets) {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         headingRowColor: WidgetStateProperty.all(
//           const Color.fromARGB(255, 152, 166, 246),
//         ),
//         columns: const [
//           DataColumn(label: Text('ID')),
//           DataColumn(label: Text('Name')),
//           DataColumn(label: Text('Status')),
//           DataColumn(label: Text('Price')),
//           DataColumn(label: Text('Actions')),
//         ],
//         rows: assets.map((asset) {
//           return DataRow(
//             cells: [
//               DataCell(
//                 Text(asset['id'].toString()),
//               ),
//               DataCell(
//                 Text(asset['name'] ?? ''),
//               ),
              
//               DataCell(
//                 Builder(
//                   builder: (context) {
//                     final status = asset['status']?.toString().toLowerCase() ?? '';

//                     Color color;

//                     switch (status) {
//                       case 'assigned':
//                         color = Colors.green;
//                         break;
//                       case 'under maintenance':
//                         color = Colors.orange;
//                         break;
//                       case 'available':
//                         color = Colors.red;
//                         break;
//                       default:
//                         color = Colors.grey;
//                     }

//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       // decoration: BoxDecoration(
//                       //   color: color.withValues(alpha: 0.15),
//                       //   borderRadius: BorderRadius.circular(20),
//                       // ),
//                       child: Text(
//                         asset['status'] ?? '',
//                         style: TextStyle(
//                           color: color,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               DataCell(
//                 Text(
//                   asset['price']?.toString() ?? '0',
//                 ),
//               ),
//               DataCell(
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.visibility),
//                       onPressed: () => showDialog<String>(
//                         context: context,
//                         builder: (BuildContext context) => Dialog(
//                           child: Padding(
//                             padding: const .all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Text("Asset ${asset['id'].toString()}"),
//                                 Text("Name: ${asset['name']}"),
//                                 Text("Status: ${asset['status']}"),
//                                 Text("Brand: ${asset['brand']}"),
//                                 Text("Assiged To: ${asset['current_assignment']['user']['username']}"),
//                                 Text("Price: ${asset['price']}"),
//                                 Text("Warranty Expiration: ${asset['Warranty']}"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // IconButton(
//                     //   icon: const Icon(Icons.edit),
//                     //   onPressed: () {
//                     //     print(
//                     //       'Edit ${asset['id']}',
//                     //     );
//                     //   },
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

@override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Asset List')),
        body: loadingAssets 
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : assets.isEmpty
                ? const Center(
                    child: Text('No assets found'),
                  ) 
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                        final asset = assets[index];
                        return AssetCard(
                          asset: asset,
                          // onTap(){
                            
                          // },
                        );
                    },
                  )
      ),
    );
  }

}