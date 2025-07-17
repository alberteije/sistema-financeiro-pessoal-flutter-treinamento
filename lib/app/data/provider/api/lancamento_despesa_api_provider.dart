import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class LancamentoDespesaApiProvider extends ApiProviderBase {

	Future<List<LancamentoDespesaModel>?> getList({Filter? filter}) async {
		List<LancamentoDespesaModel> lancamentoDespesaModelList = [];

		try {
			handleFilter(filter, '/lancamento-despesa/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoDespesaModelJson = json.decode(response.body) as List<dynamic>;
					for (var lancamentoDespesaModel in lancamentoDespesaModelJson) {
						lancamentoDespesaModelList.add(LancamentoDespesaModel.fromJson(lancamentoDespesaModel));
					}
					return lancamentoDespesaModelList;
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

	Future<LancamentoDespesaModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/lancamento-despesa/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoDespesaModelJson = json.decode(response.body);
					return LancamentoDespesaModel.fromJson(lancamentoDespesaModelJson);		 
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

	Future<LancamentoDespesaModel?>? insert(LancamentoDespesaModel lancamentoDespesaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/lancamento-despesa')!,
				headers: ApiProviderBase.headerRequisition(),
				body: lancamentoDespesaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoDespesaModelJson = json.decode(response.body);
					return LancamentoDespesaModel.fromJson(lancamentoDespesaModelJson);
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

	Future<LancamentoDespesaModel?>? update(LancamentoDespesaModel lancamentoDespesaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/lancamento-despesa')!,
				headers: ApiProviderBase.headerRequisition(),
				body: lancamentoDespesaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var lancamentoDespesaModelJson = json.decode(response.body);
					return LancamentoDespesaModel.fromJson(lancamentoDespesaModelJson);
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
				Uri.tryParse('$endpoint/lancamento-despesa/$pk')!,
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
