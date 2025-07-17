import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';

import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/lancamento_despesa_repository.dart';

class LancamentoDespesaController extends ControllerBase<LancamentoDespesaModel, LancamentoDespesaRepository> {

  LancamentoDespesaController({required super.repository}) {
    dbColumns = LancamentoDespesaModel.dbColumns;
    aliasColumns = LancamentoDespesaModel.aliasColumns;
    gridColumns = lancamentoDespesaGridColumns();
    functionName = "lancamento_despesa";
    screenTitle = "Lançamento de Despesa";
  }

  @override
  LancamentoDespesaModel createNewModel() => LancamentoDespesaModel();

  @override
  final standardFieldForFilter = LancamentoDespesaModel.aliasColumns[LancamentoDespesaModel.dbColumns.indexOf('data_despesa')];

  final contaDespesaModelController = TextEditingController();
  final metodoPagamentoModelController = TextEditingController();
  final dataDespesaController = DatePickerItemController(null);
  final valorController = MoneyMaskedTextController();
  final statusDespesaController = CustomDropdownButtonController('Pago');
  final historicoController = TextEditingController();

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['data_despesa'],
    'secondaryColumns': ['valor'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((lancamentoDespesa) => lancamentoDespesa.toJson).toList();
  }

  @override
  void prepareForInsert() {
    isNewRecord = true;
    currentModel = createNewModel();
    _resetForm();
    Get.toNamed(Routes.lancamentoDespesaEditPage);
  }

  void _resetForm() {
    formWasChanged = false;
    contaDespesaModelController.text = '';
    metodoPagamentoModelController.text = '';
    dataDespesaController.date = null;
    valorController.updateValue(0);
    statusDespesaController.selected = 'Pago';
    historicoController.text = '';
  }

  @override
  void selectRowForEditingById(int id) {
    final model = modelList.firstWhere((m) => m.id == id);
    currentModel = model.clone();
    updateControllersFromModel();
    Get.toNamed(Routes.lancamentoDespesaEditPage);
  }

  void updateControllersFromModel() {
    contaDespesaModelController.text = currentModel.contaDespesaModel?.descricao?.toString() ?? '';
    metodoPagamentoModelController.text = currentModel.metodoPagamentoModel?.descricao?.toString() ?? '';
    dataDespesaController.date = currentModel.dataDespesa;
    valorController.updateValue(currentModel.valor ?? 0);
    statusDespesaController.selected = currentModel.statusDespesa ?? 'Pago';
    historicoController.text = currentModel.historico ?? '';
    formWasChanged = false;
  }

  @override
  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      showErrorSnackBar(message: 'validator_form_message'.tr);
      return;
    }

    final existingIndex = modelList.indexWhere((m) => m.id == currentModel.id);

    if (existingIndex >= 0) {
      modelList[existingIndex] = currentModel.clone();
    }

    final result = await repository.save(lancamentoDespesaModel: currentModel);
    if (result == null) return;

    if (existingIndex >= 0) {
      modelList[existingIndex] = result;
    } else {
      modelList.insert(0, result);
    }

    if (!GetPlatform.isMobile) {
      updateGridRow(result);
    }

    Get.back(result: true);
  }

  Future callContaDespesaLookup() async { 
		final lookupController = Get.find<LookupController>(); 
		lookupController.refreshItems(standardValue: '%'); 
		lookupController.title = '${'lookup_page_title'.tr} [Conta]'; 
		lookupController.route = '/conta-despesa/'; 
		lookupController.gridColumns = contaDespesaGridColumns(isForLookup: true); 
		lookupController.aliasColumns = ContaDespesaModel.aliasColumns; 
		lookupController.dbColumns = ContaDespesaModel.dbColumns; 
		lookupController.standardColumn = ContaDespesaModel.aliasColumns[ContaDespesaModel.dbColumns.indexOf('descricao')]; 

		final plutoRowResult = await Get.toNamed(Routes.lookupPage); 
		if (plutoRowResult != null) { 
			currentModel.idContaDespesa = plutoRowResult.cells['id']!.value; 
			currentModel.contaDespesaModel = ContaDespesaModel.fromPlutoRow(plutoRowResult); 
			contaDespesaModelController.text = currentModel.contaDespesaModel?.descricao ?? ''; 
			formWasChanged = true; 
		}
	}

  Future callMetodoPagamentoLookup() async { 
		final lookupController = Get.find<LookupController>(); 
		lookupController.refreshItems(standardValue: '%'); 
		lookupController.title = '${'lookup_page_title'.tr} [Método Pagamento]'; 
		lookupController.route = '/metodo-pagamento/'; 
		lookupController.gridColumns = metodoPagamentoGridColumns(isForLookup: true); 
		lookupController.aliasColumns = MetodoPagamentoModel.aliasColumns; 
		lookupController.dbColumns = MetodoPagamentoModel.dbColumns; 
		lookupController.standardColumn = MetodoPagamentoModel.aliasColumns[MetodoPagamentoModel.dbColumns.indexOf('descricao')]; 

		final plutoRowResult = await Get.toNamed(Routes.lookupPage); 
		if (plutoRowResult != null) { 
			currentModel.idMetodoPagamento = plutoRowResult.cells['id']!.value; 
			currentModel.metodoPagamentoModel = MetodoPagamentoModel.fromPlutoRow(plutoRowResult); 
			metodoPagamentoModelController.text = currentModel.metodoPagamentoModel?.descricao ?? ''; 
			formWasChanged = true; 
		}
	}


  @override
  void onClose() {
    contaDespesaModelController.dispose();
    metodoPagamentoModelController.dispose();
    dataDespesaController.dispose();
    valorController.dispose();
    statusDespesaController.dispose();
    historicoController.dispose();
    super.onClose();
  }

}