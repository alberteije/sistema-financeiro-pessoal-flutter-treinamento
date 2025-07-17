import 'dart:convert';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class MetodoPagamentoApiProvider extends ApiProviderBase {

	Future<List<MetodoPagamentoModel>?> getList({Filter? filter}) async {
		List<MetodoPagamentoModel> metodoPagamentoModelList = [];

		try {
			handleFilter(filter, '/metodo-pagamento/');
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var metodoPagamentoModelJson = json.decode(response.body) as List<dynamic>;
					for (var metodoPagamentoModel in metodoPagamentoModelJson) {
						metodoPagamentoModelList.add(MetodoPagamentoModel.fromJson(metodoPagamentoModel));
					}
					return metodoPagamentoModelList;
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

	Future<MetodoPagamentoModel?> getObject(dynamic pk) async {
		try {
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse('$endpoint/metodo-pagamento/$pk')!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var metodoPagamentoModelJson = json.decode(response.body);
					return MetodoPagamentoModel.fromJson(metodoPagamentoModelJson);		 
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

	Future<MetodoPagamentoModel?>? insert(MetodoPagamentoModel metodoPagamentoModel) async {
		try {
			final response = await ApiProviderBase.httpClient.post(
				Uri.tryParse('$endpoint/metodo-pagamento')!,
				headers: ApiProviderBase.headerRequisition(),
				body: metodoPagamentoModel.objectEncodeJson(),
			);

			if (response.statusCode == 200 || response.statusCode == 201) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var metodoPagamentoModelJson = json.decode(response.body);
					return MetodoPagamentoModel.fromJson(metodoPagamentoModelJson);
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

	Future<MetodoPagamentoModel?>? update(MetodoPagamentoModel metodoPagamentoModel) async {
		try {
			final response = await ApiProviderBase.httpClient.put(
				Uri.tryParse('$endpoint/metodo-pagamento')!,
				headers: ApiProviderBase.headerRequisition(),
				body: metodoPagamentoModel.objectEncodeJson(),
			);

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					var metodoPagamentoModelJson = json.decode(response.body);
					return MetodoPagamentoModel.fromJson(metodoPagamentoModelJson);
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
				Uri.tryParse('$endpoint/metodo-pagamento/$pk')!,
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
