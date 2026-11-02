import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../components/NowUI/input.dart';
import '../../constant/path.dart';
import '../../constant/theme.dart';
import '../../controller/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: NowUIColors.bgColorScreen,
        child: const Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 20.0, right: 20.0, bottom: 32),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.58,
          color: NowUIColors.bgColorScreen,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      AssetStorage.logo,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Input(
                            placeholder: "Username",
                            prefixIcon: const Icon(
                              Icons.email,
                              size: 20,
                              color: NowUIColors.primary,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (v) => controller.email = v,
                          ),
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                              bottom: 0,
                            ),
                            child: Input(
                              placeholder: "Password",
                              prefixIcon: const Icon(
                                Icons.lock,
                                size: 20,
                                color: NowUIColors.primary,
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: controller.invisiblePassword.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  !controller.invisiblePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  controller.invisiblePassword.value =
                                      !controller.invisiblePassword.value;
                                },
                              ),
                              onChanged: (v) => controller.password = v,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: controller.submit,

                      child: const Padding( 
                        padding: EdgeInsets.only(
                            left: 32.0, right: 32.0, top: 12, bottom: 12),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
