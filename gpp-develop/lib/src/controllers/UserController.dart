// import 'package:gpp/src/models/FuncionalidadeModel.dart';
// import 'package:gpp/src/models/subfuncionalities_model.dart';
// import 'package:gpp/src/models/user_model.dart';
// import 'package:gpp/src/repositories/UsuarioRepository.dart';
// import 'package:gpp/src/shared/enumeration/user_enum.dart';
// import 'package:gpp/src/shared/repositories/global.dart';

// class UsuarioController {
//   UsuarioRepository repository = UsuarioRepository();
//   UsuarioModel user = UsuarioModel();
//   List<UsuarioModel> users = [];
//   List<UsuarioModel> usersSearch = [];
//   List<SubFuncionalidadeModel> subFuncionalities = [];
//   UserEnum state = UserEnum.notUser;
//   List<FuncionalidadeModel> funcionalities = [];
//   List<FuncionalidadeModel> funcionalitiesSearch = [];

//   Future<void> fetchUser(String id) async {
//     user = await repository.fetchUser(id);
//   }

//   Future<void> changeUser() async {
//     users = await repository.buscarUsuarios();
//   }

//   Future<void> changeUserFuncionalities(String id) async {
//     subFuncionalities = await repository.fetchSubFuncionalities(id);
//   }

//   void search(String value) {
//     usersSearch = users
//         .where((user) =>
//             (user.nome!.toLowerCase().contains(value.toLowerCase()) ||
//                 user.uid!.toString().contains(value.toLowerCase())))
//         .toList();
//   }

//   Future<bool> updateUserSubFuncionalities(
//       UsuarioModel user, List<SubFuncionalidadeModel> subFuncionalities) async {
//     return await repository.updateUserSubFuncionalities(
//         user, subFuncionalities);
//   }

//   Future<void> changeFuncionalities() async {
//     UsuarioModel user = UsuarioModel();
//     user.id = authenticateUser!.id;

//     funcionalities = await repository.buscarFuncionalidades(user.id!);
//   }

//   void searchFuncionalities(String value) {
//     funcionalitiesSearch = [];

//     if (value != "") {
//       for (var funcionalitie in funcionalities) {
//         for (var subFuncionalitie in funcionalitie.subFuncionalidades!) {
//           if (funcionalitie.nome!.toLowerCase().contains(value.toLowerCase()) ||
//               subFuncionalitie.nome!
//                   .toLowerCase()
//                   .contains(value.toLowerCase())) {
//             funcionalitie.isExpanded = true;
//             funcionalitiesSearch.add(funcionalitie);
//             break;
//           }
//         }
//       }
//     }
//   }

//   Future<bool> update(UsuarioModel user) async {
//     return await repository.update(user);
//   }

// /***
//  * 
//  * Função responsável por buscar as funcionalidades do usuário
//  */

//   buscarFuncionalidades(int id) async {
//     this.funcionalities = await repository.buscarFuncionalidades(id);
//   }
// }
