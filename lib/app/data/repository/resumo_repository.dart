import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/resumo_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/resumo_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ResumoRepository {
  final ResumoApiProvider resumoApiProvider;
  final ResumoDriftProvider resumoDriftProvider;

  ResumoRepository({required this.resumoApiProvider, required this.resumoDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await resumoDriftProvider.getList(filter: filter);
    } else {
      return await resumoApiProvider.getList(filter: filter);
    }
  }

  Future<ResumoModel?>? save({required ResumoModel resumoModel}) async {
    if (resumoModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await resumoDriftProvider.update(resumoModel);
      } else {
        return await resumoApiProvider.update(resumoModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await resumoDriftProvider.insert(resumoModel);
      } else {
        return await resumoApiProvider.insert(resumoModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await resumoDriftProvider.delete(id) ?? false;
    } else {
      return await resumoApiProvider.delete(id) ?? false;
    }
  }

  Future doSummary(String selectedDate) async {
    await resumoDriftProvider.doSummary(selectedDate);
  }

  Future saveAll(List<ResumoModel> resumoList) async {
    await resumoDriftProvider.saveAll(resumoList);
  }

  Future calculateSummarryForAMonth(String selectedDate, Filter filter) async {
    await resumoDriftProvider.calculateSummarryForAMonth(selectedDate, filter);
  }

}