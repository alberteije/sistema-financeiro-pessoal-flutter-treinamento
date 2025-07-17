import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ContaReceitaApiProvider extends ApiProviderBase {

	Future<List<ContaReceitaModel>?> getList({Filter? filter}) async {
		List<ContaReceitaModel> contaReceitaModelList = [];

		try {
			handleFilter(filter, '/conta-receita/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaReceitaModelJson = json.decode(response.body) as List<dynamic>;
					for (var contaReceitaModel in contaReceitaModelJson) {
						contaReceitaModelList.add(ContaReceitaModel.fromJson(contaReceitaModel));
					}
					return contaReceitaModelList;
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

	Future<ContaReceitaModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/conta-receita/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaReceitaModelJson = json.decode(response.body);
					return ContaReceitaModel.fromJson(contaReceitaModelJson);		 
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

	Future<ContaReceitaModel?>? insert(ContaReceitaModel contaReceitaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/conta-receita')!,
				headers: ApiProviderBase.headerRequisition(),
				body: contaReceitaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaReceitaModelJson = json.decode(response.body);
					return ContaReceitaModel.fromJson(contaReceitaModelJson);
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

	Future<ContaReceitaModel?>? update(ContaReceitaModel contaReceitaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/conta-receita')!,
				headers: ApiProviderBase.headerRequisition(),
				body: contaReceitaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaReceitaModelJson = json.decode(response.body);
					return ContaReceitaModel.fromJson(contaReceitaModelJson);
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
				Uri.tryParse('$endpoint/conta-receita/$pk')!,
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
