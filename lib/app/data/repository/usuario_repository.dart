import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/usuario_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/usuario_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class UsuarioRepository {
  final UsuarioApiProvider usuarioApiProvider;
  final UsuarioDriftProvider usuarioDriftProvider;

  UsuarioRepository({required this.usuarioApiProvider, required this.usuarioDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await usuarioDriftProvider.getList(filter: filter);
    } else {
      return await usuarioApiProvider.getList(filter: filter);
    }
  }

  Future<UsuarioModel?>? save({required UsuarioModel usuarioModel}) async {
    if (usuarioModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await usuarioDriftProvider.update(usuarioModel);
      } else {
        return await usuarioApiProvider.update(usuarioModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await usuarioDriftProvider.insert(usuarioModel);
      } else {
        return await usuarioApiProvider.insert(usuarioModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await usuarioDriftProvider.delete(id) ?? false;
    } else {
      return await usuarioApiProvider.delete(id) ?? false;
    }
  }

  Future<bool> doLogin(String user, String password) async {
    return await usuarioDriftProvider.doLogin(user, password);
  }

}