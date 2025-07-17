import 'package:financeiro_pessoal/app/data/provider/drift/database/database_imports.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/data/provider/provider_base.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/database/database.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/domain/domain_imports.dart';

class ResumoDriftProvider extends ProviderBase {

	Future<List<ResumoModel>?> getList({Filter? filter}) async {
		List<ResumoGrouped> resumoDriftList = [];

		try {
			if (filter != null && filter.field != null) {
				resumoDriftList = await Session.database.resumoDao.getGroupedList(field: filter.field, value: filter.value!);
			} else {
				resumoDriftList = await Session.database.resumoDao.getGroupedList(); 
			}
			if (resumoDriftList.isNotEmpty) {
				return toListModel(resumoDriftList);
			} else {
				return [];
			}			 
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
			return null;
		}
	}

	Future<ResumoModel?> getObject(dynamic pk) async {
		try {
			final result = await Session.database.resumoDao.getObjectGrouped(field: 'id', value: pk);
			return toModel(result);
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<ResumoModel?>? insert(ResumoModel resumoModel) async {
		try {
			final lastPk = await Session.database.resumoDao.insertObject(toDrift(resumoModel));
			resumoModel.id = lastPk;
			return resumoModel;
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<ResumoModel?>? update(ResumoModel resumoModel) async {
		try {
			await Session.database.resumoDao.updateObject(toDrift(resumoModel));
			return resumoModel;
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<bool?> delete(dynamic pk) async {
		try {
			await Session.database.resumoDao.deleteObject(toDrift(ResumoModel(id: pk)));
			return true;
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}	

  Future doSummary(String selectedDate) async {
    try {
      await Session.database.resumoDao.doSummary(selectedDate);
    } on Exception catch (e) {
      handleResultError(null, null, exception: e);
    }
  }

  Future saveAll(List<ResumoModel> resumoList) async {
    try {
      for (var resumo in resumoList) {
        if (resumo.id! > 0) {
          await update(resumo);
        } else {
          await insert(resumo);
        }
      }
    } on Exception catch (e) {
      handleResultError(null, null, exception: e);
    }
  }

  Future calculateSummarryForAMonth(String selectedDate, Filter filter) async {
    try {
      await Session.database.resumoDao.calculateSummarryForAMonth(selectedDate, filter);
    } on Exception catch (e) {
      handleResultError(null, null, exception: e);
    }
  }

	List<ResumoModel> toListModel(List<ResumoGrouped> resumoDriftList) {
		List<ResumoModel> listModel = [];
		for (var resumoDrift in resumoDriftList) {
			listModel.add(toModel(resumoDrift)!);
		}
		return listModel;
	}	

	ResumoModel? toModel(ResumoGrouped? resumoDrift) {
		if (resumoDrift != null) {
			return ResumoModel(
				id: resumoDrift.resumo?.id,
				receitaDespesa: ResumoDomain.getReceitaDespesa(resumoDrift.resumo?.receitaDespesa),
				codigo: resumoDrift.resumo?.codigo,
				descricao: resumoDrift.resumo?.descricao,
				valorOrcado: resumoDrift.resumo?.valorOrcado,
				valorRealizado: resumoDrift.resumo?.valorRealizado,
				mesAno: resumoDrift.resumo?.mesAno,
				diferenca: resumoDrift.resumo?.diferenca,
			);
		} else {
			return null;
		}
	}


	ResumoGrouped toDrift(ResumoModel resumoModel) {
		return ResumoGrouped(
			resumo: Resumo(
				id: resumoModel.id,
				receitaDespesa: ResumoDomain.setReceitaDespesa(resumoModel.receitaDespesa),
				codigo: resumoModel.codigo,
				descricao: resumoModel.descricao,
				valorOrcado: resumoModel.valorOrcado,
				valorRealizado: resumoModel.valorRealizado,
				mesAno: resumoModel.mesAno,
				diferenca: resumoModel.diferenca,
			),
		);
	}

		
}
