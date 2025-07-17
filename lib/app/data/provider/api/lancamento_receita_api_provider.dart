import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class LancamentoReceitaApiProvider extends ApiProviderBase {

	Future<List<LancamentoReceitaModel>?> getList({Filter? filter}) async {
		List<LancamentoReceitaModel> lancamentoReceitaModelList = [];

		try {
			handleFilter(filter, '/lancamento-receita/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoReceitaModelJson = json.decode(response.body) as List<dynamic>;
					for (var lancamentoReceitaModel in lancamentoReceitaModelJson) {
						lancamentoReceitaModelList.add(LancamentoReceitaModel.fromJson(lancamentoReceitaModel));
					}
					return lancamentoReceitaModelList;
				}
			} else {
				handleResultError(response.body, response.headers);
				return null;
			}
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
			return null;
		}
	}

	Future<LancamentoReceitaModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/lancamento-receita/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoReceitaModelJson = json.decode(response.body);
					return LancamentoReceitaModel.fromJson(lancamentoReceitaModelJson);		 
				}
			} else {
				handleResultError(response.body, response.headers);
				return null;
			}
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<LancamentoReceitaModel?>? insert(LancamentoReceitaModel lancamentoReceitaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/lancamento-receita')!,
				headers: ApiProviderBase.headerRequisition(),
				body: lancamentoReceitaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoReceitaModelJson = json.decode(response.body);
					return LancamentoReceitaModel.fromJson(lancamentoReceitaModelJson);
				}
			} else {
				handleResultError(response.body, response.headers);
				return null;
			}
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<LancamentoReceitaModel?>? update(LancamentoReceitaModel lancamentoReceitaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/lancamento-receita')!,
				headers: ApiProviderBase.headerRequisition(),
				body: lancamentoReceitaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoReceitaModelJson = json.decode(response.body);
					return LancamentoReceitaModel.fromJson(lancamentoReceitaModelJson);
				}
			} else {
				handleResultError(response.body, response.headers);
				return null;
			}
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}

	Future<bool?> delete(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.delete(
				Uri.tryParse('$endpoint/lancamento-receita/$pk')!,
				headers: ApiProviderBase.headerRequisition(),
			);

			if (response.statusCode == 200) {
				return true;
			} else {
				handleResultError(response.body, response.headers);
				return null;
			}
		} on Exception catch (e) {
			handleResultError(null, null, exception: e);
		}
		return null;
	}	
}
