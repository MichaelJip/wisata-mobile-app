import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_remote_datasource.dart';
import 'package:wisata_app/data/models/request/login_request_model.dart';
import 'package:wisata_app/ui/auth/bloc/login/login_bloc.dart';
import 'package:wisata_app/ui/home/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SizedBox(
            height: 260.0,
            child: Center(child: Assets.images.logoWhite.image(height: 55.0)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                child: ColoredBox(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 44.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: emailController,
                          label: 'Email',
                          isOutlineBorder: false,
                        ),
                        const SpaceHeight(36.0),
                        CustomTextField(
                          controller: passwordController,
                          label: 'Password',
                          isOutlineBorder: false,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SpaceHeight(32.0),
                        BlocConsumer<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return Button.filled(
                              disabled: state is LoginLoading,
                              label: state is LoginLoading
                                  ? 'Loading...'
                                  : "Login",
                              onPressed: () {
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    LoginRequestModel(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          listener: (context, state) async {
                            if (state is LoginSuccess) {
                              await AuthLocalDataResource().saveToken(
                                state.data.token ?? '',
                              );
                              if (!context.mounted) return;
                              context.pushReplacement(const MainPage());
                            } else if (state is LoginFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                        ),
                        const SpaceHeight(128.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
