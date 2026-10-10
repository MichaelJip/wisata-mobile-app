import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_local_datasource.dart';
import 'package:wisata_app/data/datasources/auth_remote_datasource.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/datasources/product_remote_datasource.dart';
import 'package:wisata_app/data/wisata_api.dart';
import 'package:wisata_app/ui/auth/bloc/login/login_bloc.dart';
import 'package:wisata_app/ui/auth/splash_page.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';
import 'package:wisata_app/ui/home/bloc/order/order_bloc.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';

final api = WisataApi();
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LoginBloc(AuthRemoteDatasource(api.dio), AuthLocalDatasource()),
        ),
        BlocProvider(
          create: (_) =>
              ProductBloc(
                  ProductRemoteDatasource(api.dio),
                  ProductLocalDatasource(),
                )
                ..add(ProductLocalFetched())
                ..add(ProductSynced()),
        ),
        BlocProvider(create: (_) => CheckoutBloc()),
        BlocProvider(
          create: (_) =>
              OrderBloc(ProductLocalDatasource(), AuthLocalDatasource()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Pensi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        dialogTheme: const DialogThemeData(elevation: 0),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.outfit(
            color: AppColors.primary,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
          centerTitle: true,
        ),
      ),
      home: const SplashPage(),
    );
  }
}
