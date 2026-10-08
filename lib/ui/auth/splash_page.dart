import 'package:flutter/material.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_remote_datasource.dart';
import 'package:wisata_app/ui/auth/login_page.dart';
import 'package:wisata_app/ui/home/main_page.dart';

class SplashPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final token = await AuthLocalDataResource().getToken();
    if (!mounted) return;
    context.pushReplacement(
      token != null && token.isNotEmpty ? const MainPage() : const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(96.0),
        child: Center(child: Assets.images.logoBlue.image()),
      ),
      // bottomNavigationBar: SizedBox(
      //   height: 100.0,
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Assets.images.logoCwb.image(width: 96.0),
      //   ),
      // ),
    );
  }
}
