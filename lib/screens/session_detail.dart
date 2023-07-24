import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pionixbox/screens/session_detail_graphs.dart';
import 'package:pionixbox/screens/session_detail_screen.dart';
import 'package:pionixbox/theme/app_colors.dart';
import 'package:pionixbox/theme/app_text_styles.dart';

class SessionDetail extends StatefulWidget {
  const SessionDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<SessionDetail> createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.primaryBlue,
                flexibleSpace:
                    TabBar(labelStyle: AppTextStyles.subTitle4, tabs: [
                  Tab(
                    icon: const Icon(Icons.info),
                    text: "session_details".tr(),
                  ),
                  Tab(
                    icon: const Icon(Icons.insights),
                    text: "session_details_graphs".tr(),
                  ),
                ])),
            body: const TabBarView(
                children: [SessionDetailScreen(), SessionDetailGraphs()])));
  }
}
