import 'package:get/get.dart';

import '../modules/devices/bindings/devices_binding.dart';
import '../modules/devices/button/bindings/button_binding.dart';
import '../modules/devices/button/views/button_view.dart';
import '../modules/devices/chat/bindings/chat_binding.dart';
import '../modules/devices/chat/views/chat_view.dart';
import '../modules/devices/joystick/bindings/joystick_binding.dart';
import '../modules/devices/joystick/views/joystick_view.dart';
import '../modules/devices/views/devices_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/nomopro/bindings/nomopro_binding.dart';
import '../modules/nomopro/views/nomopro_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/project/bindings/project_binding.dart';
import '../modules/project/views/project_view.dart';
import '../modules/stetting/bindings/stetting_binding.dart';
import '../modules/stetting/views/stetting_view.dart';
import '../modules/upload_project/bindings/upload_project_binding.dart';
import '../modules/upload_project/views/upload_project_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
      name: _Paths.DEVICES,
      page: () => const DevicesView(),
      binding: DevicesBinding(),
      children: [
        GetPage(
          name: _Paths.CHAT,
          page: () => const ChatView(),
          binding: ChatBinding(),
        ),
        GetPage(
          name: _Paths.BUTTON,
          page: () => const ButtonView(),
          binding: ButtonBinding(),
        ),
        GetPage(
          name: _Paths.JOYSTICK,
          page: () => const JoystickView(),
          binding: JoystickBinding(),
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
    GetPage(
      name: _Paths.NOMOPRO,
      page: () => const NomoproView(),
      binding: NomoproBinding(),
    ),
    GetPage(
      name: _Paths.PROJECT,
      page: () => const ProjectView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_PROJECT,
      page: () => const UploadProjectView(),
      binding: UploadProjectBinding(),
    ),
  ];
}
