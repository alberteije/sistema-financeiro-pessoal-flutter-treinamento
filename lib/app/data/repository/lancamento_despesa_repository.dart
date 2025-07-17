import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/lancamento_despesa_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/lancamento_despesa_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class LancamentoDespesaRepository {
  final LancamentoDespesaApiProvider lancamentoDespesaApiProvider;
  final LancamentoDespesaDriftProvider lancamentoDespesaDriftProvider;

  LancamentoDespesaRepository({required this.lancamentoDespesaApiProvider, required this.lancamentoDespesaDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await lancamentoDespesaDriftProvider.getList(filter: filter);
    } else {
      return await lancamentoDespesaApiProvider.getList(filter: filter);
    }
  }

  Future<LancamentoDespesaModel?>? save({required LancamentoDespesaModel lancamentoDespesaModel}) async {
    if (lancamentoDespesaModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await lancamentoDespesaDriftProvider.update(lancamentoDespesaModel);
      } else {
        return await lancamentoDespesaApiProvider.update(lancamentoDespesaModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await lancamentoDespesaDriftProvider.insert(lancamentoDespesaModel);
      } else {
        return await lancamentoDespesaApiProvider.insert(lancamentoDespesaModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await lancamentoDespesaDriftProvider.delete(id) ?? false;
    } else {
      return await lancamentoDespesaApiProvider.delete(id) ?? false;
    }
  }
}