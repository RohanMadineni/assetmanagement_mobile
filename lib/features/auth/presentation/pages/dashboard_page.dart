import 'package:flutter/material.dart';
import '../../data/services/asset_service.dart';
import '../../../../core/network/api_client.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/layout/main_layout.dart';
class DashboardPage extends StatefulWidget{
    const DashboardPage({super.key});
    @override
    State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
    late final AssetService assetService;

    Map<String, dynamic>? stats;
    List<dynamic> upcomingWarranties = [];
    List<dynamic> recentlyAssigned = [];

    bool loadingWarranties = true;
    bool loadingRecent = true;
    
    // late final int totalAssets;
    // late final int assignedAssets;
    // late final int maintenanceAssets;
    // late final int totalValue;
    // late final int categories;
    @override
    void initState() {
        super.initState(); 
        assetService = AssetService(
            ApiClient(),
        );
        loadStats();
        loadData();
    }
    Future<void> loadStats() async{
        final result = await assetService.getStats();
        // print(result);
        setState(() {
            stats = result.data;
            // totalAssets = stats!['total_assets'] ?? 0;
            // assignedAssets = stats!['assigned_assets'] ?? 0;
            // maintenanceAssets = stats!['under_maintenance'] ?? 0;
            // totalValue = stats!['totalvalue'] ?? 0;
            // categories = stats!['cat_Array'].length;
        });

        // print(stats);
    }
    
    Future<void> loadData() async {
      final warranties = await assetService.getUpcomingAssets();
      final recent = await assetService.getRecentlyAssignedAssets();
      // print(warranties.data);
      // print(recent.data );
      setState(() {
        upcomingWarranties = List<dynamic>.from(warranties.data['data']);
        recentlyAssigned = List<dynamic>.from(recent.data['data']);

        loadingWarranties = false;
        loadingRecent = false;
      });
    }
    @override
    Widget build(BuildContext context) {
      if (stats == null) {
        return MainLayout(
          selectedIndex: 0,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
        final totalAssets = stats?['total_assets'] ?? 0;
        final assignedAssets = stats?['assigned_assets'] ?? 0;
        final maintenanceAssets = stats?['under_maintenance'] ?? 0;
        final totalValue = stats?['totalvalue'] ?? 0;
        final categories = stats?['cat_Array']?.length ?? 0;
        return MainLayout(
          selectedIndex: 0,
          child: Scaffold(
                appBar: AppBar(title: const Text('Dashboard')),
                body: SingleChildScrollView(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                children: [
                                    GridView.count(
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        childAspectRatio: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        children: [
                                            statCard("Total Assets", "$totalAssets", Icons.inventory_2, Colors.pink),
                                            statCard("Assigned", "$assignedAssets", Icons.person, Colors.blue),
                                            statCard("Maintenance", "$maintenanceAssets", Icons.build, Colors.orange),
                                            statCard("Categories", "$categories", Icons.category, Colors.purple),
                                            statCard("Total Value", "QAR $totalValue", Icons.attach_money, Colors.green),
                                        ],
                                    ),
                                    // const SizedBox(height: 20),
                                    
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              warrantyTable(),
                                              const SizedBox(height: 16),
                                              recentlyAssignedTable(),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          flex:1,
                                          child: Column(
                                            children: [
                                              categoryChart(),
                                              const SizedBox(width: 12),
                                              statusChart(),
                                            ],
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                ],
                            ),
                        ),
            ),
        );
        
    }

    Widget statCard(String title, String value, IconData icon, Color color) {
        return Card(
            elevation: 3,
            child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(title, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                    value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                    ),
                    ),
                ],
                ),
                Icon(icon, color: color, size: 30),
            ],
            ),
        ),
    );
    }   

    Widget categoryChart(){
      final catNames = Map<String, dynamic>.from(stats!['catNames']);
      final catArray = Map<String, dynamic>.from(stats!['cat_Array']);
      final colors = [
        Colors.greenAccent,
        Colors.amberAccent,
        Colors.lightBlueAccent,
        Colors.deepPurpleAccent,
        Colors.redAccent,
      ];
      return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Assets by Category",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12),
                  
                  child: SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: catArray.entries.map((entry) {
                            final categoryId = entry.key;
                            final count = entry.value;

                            return PieChartSectionData(
                              value: count.toDouble(),
                              title: catNames[categoryId]?.toString() ?? 'Unknown',
                              color: colors[int.parse(categoryId)%5],
                            );
                          }).toList(),
                          centerSpaceRadius: 50,
                        ),
                      ),
                    ),
                  ),
              ],
        ),
        ),
      );
    }

    Widget statusChart(){
      return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Assets by Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: stats!['assigned_assets'],
                                title: 'Assigned',
                                color: Colors.amberAccent
                              ),
                              PieChartSectionData(
                                value: stats!['unassigned_assets'],
                                title: 'Available',
                                color: Colors.greenAccent
                              ),
                              PieChartSectionData(
                                value: stats!['under_maintenance'],
                                title: 'Under Maintenance',
                                color: Colors.deepPurpleAccent
                              ),
                            ],
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
          )
      )
    );
    }

    Widget recentlyAssignedTable(){
      return SizedBox(
    height: 300,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recently Assigned Assets",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: loadingRecent
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: recentlyAssigned.length,
                      itemBuilder: (context, index) {
                        final item = recentlyAssigned[index];

                        final assignment =
                            item['current_assignment'] ?? {};

                        return ListTile(
                          leading: const Icon(Icons.computer),
                          title: Text(item['name'] ?? ''),
                          subtitle: Text(
                            assignment['assigned_at'] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // navigate to details
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
    }

    Widget warrantyTable(){
      return SizedBox(
        height: 300,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upcoming Warranty Expirations",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: loadingWarranties
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: upcomingWarranties.length,
                          itemBuilder: (context, index) {
                            final item = upcomingWarranties[index];

                            return ListTile(
                              leading: const Icon(Icons.devices),
                              title: Text(item['name'] ?? ''),
                              subtitle: Text(
                                "${item['days_left']} days left",
                                style: const TextStyle(color: Colors.red),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  // navigate to asset detail
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}