import 'package:flutter/material.dart';
import 'package:quiz_app/src/features/common/responsive_widget.dart';
import 'package:quiz_app/src/features/home_screen/narrow_layout.dart';
import 'package:quiz_app/src/features/home_screen/wide_layout.dart';
import 'package:quiz_app/src/features/settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz App"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: const ResponsiveWidget(
          largeScreen: WideLayout(),
          smallScreen: NarrowLayout(),
        ));
  }
}
