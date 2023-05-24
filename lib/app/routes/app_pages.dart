import 'package:get/get.dart';

import '../modules/control/bindings/control_binding.dart';

import '../modules/control/devices/bindings/devices_binding.dart';
import '../modules/control/devices/views/devices_view.dart';

import '../modules/control/views/control_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/stetting/bindings/stetting_binding.dart';
import '../modules/stetting/views/stetting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.CONTROL,
      page: () => const ControlView(),
      binding: ControlBinding(),
      children: [
        GetPage(
          name: _Paths.DEVICES,
          page: () => const DevicesView(),
          binding: DevicesBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.STETTING,
      page: () => const StettingView(),
      binding: StettingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
