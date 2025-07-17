import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/conta_receita_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/conta_receita_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ContaReceitaRepository {
  final ContaReceitaApiProvider contaReceitaApiProvider;
  final ContaReceitaDriftProvider contaReceitaDriftProvider;

  ContaReceitaRepository({required this.contaReceitaApiProvider, required this.contaReceitaDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await contaReceitaDriftProvider.getList(filter: filter);
    } else {
      return await contaReceitaApiProvider.getList(filter: filter);
    }
  }

  Future<ContaReceitaModel?>? save({required ContaReceitaModel contaReceitaModel}) async {
    if (contaReceitaModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await contaReceitaDriftProvider.update(contaReceitaModel);
      } else {
        return await contaReceitaApiProvider.update(contaReceitaModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await contaReceitaDriftProvider.insert(contaReceitaModel);
      } else {
        return await contaReceitaApiProvider.insert(contaReceitaModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await contaReceitaDriftProvider.delete(id) ?? false;
    } else {
      return await contaReceitaApiProvider.delete(id) ?? false;
    }
  }
}