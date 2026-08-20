import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'core/app_export.dart';

void main() {
  runApp(const RexApp());
}

class RexApp extends StatelessWidget {
  const RexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: 'Rex',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(useMaterial3: true),
          routerConfig: appRouter,
        );
      },
    );
  }
}
