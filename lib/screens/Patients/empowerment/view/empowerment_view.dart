import 'package:flutter/material.dart';
import '../controller/empowerment_controller.dart';
import '../model/empowerment_model.dart';
import 'empowerment_detail_view.dart';

class EmpowermentView extends StatefulWidget {
  const EmpowermentView({super.key});

  @override
  State<EmpowermentView> createState() => _EmpowermentViewState();
}

class _EmpowermentViewState extends State<EmpowermentView>
    with SingleTickerProviderStateMixin {
  late final EmpowermentController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = EmpowermentController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empowerment Hub'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          // --- CHANGE: Explicitly set the label colors to white ---
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: 'Workouts'),
            Tab(icon: Icon(Icons.spa_outlined), text: 'Ayurveda'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContentList(_controller.workouts, Colors.blue),
          _buildContentList(_controller.ayurvedicArticles, Colors.green),
        ],
      ),
    );
  }

  Widget _buildContentList(
    List<EmpowermentContent> contentList,
    Color themeColor,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        final item = contentList[index];
        return Card(
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: themeColor.withOpacity(0.1),
              child: Icon(item.icon, color: themeColor),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmpowermentDetailView(content: item),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
