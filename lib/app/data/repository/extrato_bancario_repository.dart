import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/extrato_bancario_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/extrato_bancario_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ExtratoBancarioRepository {
  final ExtratoBancarioApiProvider extratoBancarioApiProvider;
  final ExtratoBancarioDriftProvider extratoBancarioDriftProvider;

  ExtratoBancarioRepository({required this.extratoBancarioApiProvider, required this.extratoBancarioDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await extratoBancarioDriftProvider.getList(filter: filter);
    } else {
      return await extratoBancarioApiProvider.getList(filter: filter);
    }
  }

  Future<ExtratoBancarioModel?>? save({required ExtratoBancarioModel extratoBancarioModel}) async {
    if (extratoBancarioModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await extratoBancarioDriftProvider.update(extratoBancarioModel);
      } else {
        return await extratoBancarioApiProvider.update(extratoBancarioModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await extratoBancarioDriftProvider.insert(extratoBancarioModel);
      } else {
        return await extratoBancarioApiProvider.insert(extratoBancarioModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await extratoBancarioDriftProvider.delete(id) ?? false;
    } else {
      return await extratoBancarioApiProvider.delete(id) ?? false;
    }
  }
}