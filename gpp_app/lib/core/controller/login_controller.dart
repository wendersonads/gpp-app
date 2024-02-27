import 'package:auth_migration/core/auth/usuario_service.dart';
import 'package:auth_migration/domain/service/login_service.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:get/get.dart';

import '../../domain/model/usuario_model.dart';

class LoginController extends GetxController{

    final UsuarioService _usuarioService = UsuarioService();
    final LoginService _loginService = LoginService();


 login() async {
    try {
      if (_loginService.valida) {
        Usuario usuarioLogado = _usuarioService.getUsuario();
        List<String> telasPermitidas = <String>[];
        usuarioLogado.perfilUsuario?.perfilUsuarioFuncionalidades?.forEach((element) { 
          //1-Sim,2-Não
          if (element.funcionalidade?.situacao == 1) {
            element.funcionalidade?.subFuncionalidades?.forEach((data) { 
              //1-Sim,2-Não
              if (data.situacao == 1) {
                telasPermitidas.add(data.rota!);
              }
            });
            
          }
        });
        if (telasPermitidas.isEmpty) {
          throw 'O usuário informado ainda não possui acesso ao GPP.';
          
        }else if(telasPermitidas.contains('/home')){
          Get.offAllNamed('/home');
        }else{
          Get.offAllNamed(telasPermitidas[0]);
        }
        
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
      tipoNotificacao: TipoNotificacaoEnum.error);

    }finally{
      update();
    }
  }

}