import 'package:financeiro_pessoal/app/data/provider/api/lookup_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/lookup_drift_provider.dart';
import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/model/transient/filter.dart';

class LookupRepository {
	final LookupApiProvider lookupApiProvider;
	final LookupDriftProvider lookupDriftProvider;

	LookupRepository({required this.lookupApiProvider, required this.lookupDriftProvider});

	Future getList({required String route, Filter? filter}) async {
		if (Constants.usingLocalDatabase) {
			return await lookupDriftProvider.getList(route: route, filter: filter!);
		} else {
			return await lookupApiProvider.getList(route: route, filter: filter!);
		}
	}
}