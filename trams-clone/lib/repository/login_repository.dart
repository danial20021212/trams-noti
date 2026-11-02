
import 'package:get/get.dart';
import 'package:tram/constant/constant.dart';
import 'package:tram/model/basic/auth_model.dart';
import 'package:tram/provider/no_auth_provider.dart';


import '../constant/url.dart';
import '../model/form/login/login_form_model.dart';

class LoginRepository {
  final NoAuthProvider provider = Get.find<NoAuthProvider>();

  Future<AuthModel> login(LoginFormModel model) async {
    Map<String, String> mapForm = {
      'username': model.email,
      'passwd': model.password,
      'grant_type': Constant.grantType,
      'client_id': Constant.clientId,
      'client_secret': Constant.clientSecret,
    };
    final res = await provider.store(
      UrlStorage.login,
      mapForm,
    );

    Get.log(res.data.toString());

    return AuthModel.fromJson(res.data);
  }
}
