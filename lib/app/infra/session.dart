import 'package:financeiro_pessoal/app/data/provider/api/usuario_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/usuario_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/repository/usuario_repository.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/provider/api/lookup_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/lookup_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/repository/lookup_repository.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/database/database.dart';

class LogedInUser {
  String administrador = 'S';
  String login = '';
}

class Session {
	Session._();

	static String tokenJWT = '';
	static AppDatabase database = Get.find();

	static bool waitDialogIsOpen = false;
  static List accessControlList = []; 
  static LogedInUser loggedInUser = LogedInUser();
	
	/// populate main objects for the Session
	static Future populateMainObjects() async { 
		Get.lazyPut<LoginController>(() => LoginController());
		Get.lazyPut<FilterController>(() => FilterController(), permanent: true);
    Get.lazyPut<LookupController>(() => LookupController(lookupRepository: LookupRepository(lookupApiProvider: LookupApiProvider(), lookupDriftProvider: LookupDriftProvider())), permanent: true);
    Get.lazyPut<UsuarioController>(() => UsuarioController(repository: UsuarioRepository(usuarioDriftProvider: UsuarioDriftProvider(), usuarioApiProvider: UsuarioApiProvider())), permanent: true);
	}

	static setLookupController() {
		Get.lazyPut<LookupController>(() => LookupController(lookupRepository: LookupRepository(lookupApiProvider: LookupApiProvider(), lookupDriftProvider: LookupDriftProvider())));
	}
	
	static PlutoGridLocaleText getLocaleForPlutoGrid() {
		switch (Get.locale.toString()) {
			case 'pt_BR':
				return const PlutoGridLocaleText.brazilianPortuguese();
			case 'es_ES':
				return const PlutoGridLocaleText.spanish();
			default:
				return const PlutoGridLocaleText();
		}
	}


}