import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/data/provider/provider_base.dart';
import 'package:http/http.dart' show Client;

class ApiProviderBase extends ProviderBase {
	/// defines the header sent in all requests that follow with the JWT Token
  static Map<String, String>? headerRequisition() {
    if (Session.tokenJWT.isEmpty) {
      return {"content-type": "application/json"};
    } else {
      return {"content-type": "application/json", "authorization": "Bearer ${Session.tokenJWT}"};
    }
  }
	static final httpClient = Client();

	// Server
	static final String _endpoint = '${Constants.serverAddress}:${Constants.serverPort}${Constants.serverAddressComplement}';
	get endpoint => _endpoint;
	static var _url = '';
	get url => _url;


	static final _resultJsonErrorObj = ResultJsonError();
	get resultJsonErrorObj => _resultJsonErrorObj;

	// the filter should be shipped as follows: ?filter=field||$condition||value
	// reference: https://github.com/nestjsx/crud/wiki/Requests
	void handleFilter(Filter? filter, String entity) {
		String? stringFilter = '';

		if (filter != null) {
			if (filter.condition == 'cont') {
				stringFilter = '?filter=${filter.field!}||\$cont||${filter.value!}';
			} else if (filter.condition == 'eq') {
				stringFilter = '?filter=${filter.field!}||\$eq||${filter.value!}';
			} else if (filter.condition == 'between') {
				stringFilter = '?filter=${filter.field!}||\$between||${filter.initialDate!},${filter.finalDate!}';
			} else if (filter.condition == 'where') { // in this case the filter has already been mounted on the window
				stringFilter = filter.where;
			}
		}

		_url = _endpoint + entity + stringFilter!;
	}

}