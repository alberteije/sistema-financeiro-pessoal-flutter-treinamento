import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ContaDespesaApiProvider extends ApiProviderBase {

	Future<List<ContaDespesaModel>?> getList({Filter? filter}) async {
		List<ContaDespesaModel> contaDespesaModelList = [];

		try {
			handleFilter(filter, '/conta-despesa/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaDespesaModelJson = json.decode(response.body) as List<dynamic>;
					for (var contaDespesaModel in contaDespesaModelJson) {
						contaDespesaModelList.add(ContaDespesaModel.fromJson(contaDespesaModel));
					}
					return contaDespesaModelList;
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

	Future<ContaDespesaModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/conta-despesa/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaDespesaModelJson = json.decode(response.body);
					return ContaDespesaModel.fromJson(contaDespesaModelJson);		 
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

	Future<ContaDespesaModel?>? insert(ContaDespesaModel contaDespesaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/conta-despesa')!,
				headers: ApiProviderBase.headerRequisition(),
				body: contaDespesaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaDespesaModelJson = json.decode(response.body);
					return ContaDespesaModel.fromJson(contaDespesaModelJson);
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

	Future<ContaDespesaModel?>? update(ContaDespesaModel contaDespesaModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/conta-despesa')!,
				headers: ApiProviderBase.headerRequisition(),
				body: contaDespesaModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var contaDespesaModelJson = json.decode(response.body);
					return ContaDespesaModel.fromJson(contaDespesaModelJson);
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
				Uri.tryParse('$endpoint/conta-despesa/$pk')!,
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
