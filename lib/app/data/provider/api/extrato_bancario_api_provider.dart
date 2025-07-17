import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class ExtratoBancarioApiProvider extends ApiProviderBase {

	Future<List<ExtratoBancarioModel>?> getList({Filter? filter}) async {
		List<ExtratoBancarioModel> extratoBancarioModelList = [];

		try {
			handleFilter(filter, '/extrato-bancario/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var extratoBancarioModelJson = json.decode(response.body) as List<dynamic>;
					for (var extratoBancarioModel in extratoBancarioModelJson) {
						extratoBancarioModelList.add(ExtratoBancarioModel.fromJson(extratoBancarioModel));
					}
					return extratoBancarioModelList;
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

	Future<ExtratoBancarioModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/extrato-bancario/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var extratoBancarioModelJson = json.decode(response.body);
					return ExtratoBancarioModel.fromJson(extratoBancarioModelJson);		 
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

	Future<ExtratoBancarioModel?>? insert(ExtratoBancarioModel extratoBancarioModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/extrato-bancario')!,
				headers: ApiProviderBase.headerRequisition(),
				body: extratoBancarioModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var extratoBancarioModelJson = json.decode(response.body);
					return ExtratoBancarioModel.fromJson(extratoBancarioModelJson);
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

	Future<ExtratoBancarioModel?>? update(ExtratoBancarioModel extratoBancarioModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/extrato-bancario')!,
				headers: ApiProviderBase.headerRequisition(),
				body: extratoBancarioModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var extratoBancarioModelJson = json.decode(response.body);
					return ExtratoBancarioModel.fromJson(extratoBancarioModelJson);
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
				Uri.tryParse('$endpoint/extrato-bancario/$pk')!,
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
