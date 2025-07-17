import 'package:get/get.dart';
import 'package:financeiro_pessoal/app/controller/conta_despesa_controller.dart';
import 'package:financeiro_pessoal/app/data/provider/api/conta_despesa_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/conta_despesa_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/repository/conta_despesa_repository.dart';

class ContaDespesaBindings implements Binding {
	@override
	List<Bind> dependencies() {
		return [
			Bind.lazyPut<ContaDespesaController>(() => ContaDespesaController(
					repository: ContaDespesaRepository(contaDespesaApiProvider: ContaDespesaApiProvider(), contaDespesaDriftProvider: ContaDespesaDriftProvider()))),
		];
	}
}
