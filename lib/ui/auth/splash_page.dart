import 'package:flutter/material.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_local_datasource.dart';
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
    final isLogin = await AuthLocalDatasource().isLogin();
    if (!mounted) return;
    context.pushReplacement(isLogin ? const MainPage() : const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(96.0),
        child: Center(child: Assets.images.logoBlue.image()),
      ),
    );
  }
}
