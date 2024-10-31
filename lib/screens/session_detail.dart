import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:display_app/main.dart';
import 'package:display_app/screens/session_detail_graphs.dart';
import 'package:display_app/screens/session_detail_screen.dart';
import 'package:display_app/widgets/buttons.dart';

class SessionDetail extends StatefulWidget {
  const SessionDetail({
    super.key,
  });

  @override
  State<SessionDetail> createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail>
    with SingleTickerProviderStateMixin {
  SessionDetailGraphs graphs = SessionDetailGraphs();
  late TabController
      tabController; // = MyTabController(length: 2, vsync: this, graphs: graphs);

  @override
  void initState() {
    super.initState();
    tabController = MyTabController(length: 2, vsync: this, graphs: graphs);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        floatingActionButton: const PionixCloseButton(
          inverted: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          elevation: 20,
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 66,
          flexibleSpace: makeTabBar(),
        ),
        body: makeTabBarView(),
      ),
    );
  }

  TabController makeTabController() {
    TabController controller = TabController(
      length: 2,
      vsync: this,
    );
    controller.addListener(() {
      //setState(() {
      //  _selectedIndex = _controller.index;
      //});
      //tabController.index = tabController.index;
      graphs.resetOverlay();
    });
    return controller;
  }

  TabBar makeTabBar() {
    return TabBar(
      controller: tabController,
      labelStyle: Theme.of(context).textTheme.titleLarge,
      indicatorColor: Theme.of(context).colorScheme.secondary,
      indicatorWeight: adjustScale(3),
      tabs: [
        Tab(
          icon: const Icon(Icons.info),
          text: "session_details".tr(),
        ),
        Tab(
          icon: const Icon(Icons.insights),
          text: "session_details_graphs".tr(),
        ),
      ],
    );
  }

  Widget makeTabBarView() {
    return TabBarView(
      controller: tabController,
      children: [const SessionDetailScreen(), graphs],
    );
  }
}

class MyTabController extends TabController {
  final SessionDetailGraphs graphs;

  MyTabController({
    required super.length,
    required super.vsync,
    required this.graphs,
  }) {
    addListener(() {
      //setState(() {
      //  _selectedIndex = _controller.index;
      //});
      //tabController.index = tabController.index;
      graphs.resetOverlay();
    });
  }
}
