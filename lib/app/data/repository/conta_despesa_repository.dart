import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/conta_despesa_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/conta_despesa_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ContaDespesaRepository {
  final ContaDespesaApiProvider contaDespesaApiProvider;
  final ContaDespesaDriftProvider contaDespesaDriftProvider;

  ContaDespesaRepository({required this.contaDespesaApiProvider, required this.contaDespesaDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await contaDespesaDriftProvider.getList(filter: filter);
    } else {
      return await contaDespesaApiProvider.getList(filter: filter);
    }
  }

  Future<ContaDespesaModel?>? save({required ContaDespesaModel contaDespesaModel}) async {
    if (contaDespesaModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await contaDespesaDriftProvider.update(contaDespesaModel);
      } else {
        return await contaDespesaApiProvider.update(contaDespesaModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await contaDespesaDriftProvider.insert(contaDespesaModel);
      } else {
        return await contaDespesaApiProvider.insert(contaDespesaModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await contaDespesaDriftProvider.delete(id) ?? false;
    } else {
      return await contaDespesaApiProvider.delete(id) ?? false;
    }
  }
}