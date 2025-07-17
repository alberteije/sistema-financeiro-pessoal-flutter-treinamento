import 'dart:convert';
import 'package:financeiro_pessoal/app/data/model/transient/filter.dart';
import 'package:financeiro_pessoal/app/data/provider/api/api_provider_base.dart';

class LookupApiProvider extends ApiProviderBase {

	Future<List<dynamic>?> getList({required String route, required Filter filter}) async {

		try {
			handleFilter(filter, route);
			
			final response = await ApiProviderBase.httpClient.get(Uri.tryParse(url)!, headers: ApiProviderBase.headerRequisition());

			if (response.statusCode == 200) {
				if (response.headers["content-type"]!.contains("html")) {
					handleResultError(response.body, response.headers);
					return null;
				} else {
					return json.decode(response.body) as List<dynamic>;
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
}
