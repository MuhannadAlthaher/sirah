import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/onboarding/onboarding.dart';

void main() {
  runApp(const MainApp());
}

/// The app's root. Blocs that a screen needs are provided here, once,
/// rather than by whichever screen happens to use them first — so
/// every Bloc in the app is discoverable from a single place, and
/// state like [DashboardBloc]'s survives navigating away and back.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => DashboardBloc())],
      child: const MaterialApp(home: Onboarding()),
    );
  }
}
