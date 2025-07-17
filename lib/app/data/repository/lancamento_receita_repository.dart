import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/lancamento_receita_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/lancamento_receita_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class LancamentoReceitaRepository {
  final LancamentoReceitaApiProvider lancamentoReceitaApiProvider;
  final LancamentoReceitaDriftProvider lancamentoReceitaDriftProvider;

  LancamentoReceitaRepository({required this.lancamentoReceitaApiProvider, required this.lancamentoReceitaDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await lancamentoReceitaDriftProvider.getList(filter: filter);
    } else {
      return await lancamentoReceitaApiProvider.getList(filter: filter);
    }
  }

  Future<LancamentoReceitaModel?>? save({required LancamentoReceitaModel lancamentoReceitaModel}) async {
    if (lancamentoReceitaModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await lancamentoReceitaDriftProvider.update(lancamentoReceitaModel);
      } else {
        return await lancamentoReceitaApiProvider.update(lancamentoReceitaModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await lancamentoReceitaDriftProvider.insert(lancamentoReceitaModel);
      } else {
        return await lancamentoReceitaApiProvider.insert(lancamentoReceitaModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await lancamentoReceitaDriftProvider.delete(id) ?? false;
    } else {
      return await lancamentoReceitaApiProvider.delete(id) ?? false;
    }
  }

  Future transferDataFromOtherMonth(String selectedDate, String targetDate) async {
    await lancamentoReceitaDriftProvider.transferDataFromOtherMonth(selectedDate, targetDate);
  }

}