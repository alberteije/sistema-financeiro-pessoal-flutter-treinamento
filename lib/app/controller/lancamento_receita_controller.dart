import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/lancamento_receita_repository.dart';

class LancamentoReceitaController extends ControllerBase<LancamentoReceitaModel, LancamentoReceitaRepository> {

  LancamentoReceitaController({required super.repository}) {
    dbColumns = LancamentoReceitaModel.dbColumns;
    aliasColumns = LancamentoReceitaModel.aliasColumns;
    gridColumns = lancamentoReceitaGridColumns();
    functionName = "lancamento_receita";
    screenTitle = "Lançamento de Receita";
  }

  String mesAno = "";

  final _aReceber = 0.0.obs;
  double get aReceber => _aReceber.value;
  set aReceber(double value) => _aReceber.value = value;

  final _recebido = 0.0.obs;
  double get recebido => _recebido.value;
  set recebido(double value) => _recebido.value = value;

  final _total = 0.0.obs;
  double get total => _total.value;
  set total(double value) => _total.value = value;


  @override
  LancamentoReceitaModel createNewModel() => LancamentoReceitaModel();

  @override
  final standardFieldForFilter = LancamentoReceitaModel.aliasColumns[LancamentoReceitaModel.dbColumns.indexOf('data_receita')];

  final contaReceitaModelController = TextEditingController();
  final metodoPagamentoModelController = TextEditingController();
  final dataReceitaController = DatePickerItemController(null);
  final valorController = MoneyMaskedTextController();
  final statusReceitaController = CustomDropdownButtonController('Recebido');
  final historicoController = TextEditingController();

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['data_receita'],
    'secondaryColumns': ['valor'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((lancamentoReceita) => lancamentoReceita.toJson).toList();
  }

  @override
  Future<void> getList({Filter? filter}) async {
    filter = Util.applyMonthYearToFilter(mesAno, filter ?? Filter());
    await super.getList(filter: filter);
  }

  @override
  Future<void> loadData() async {
    await super.loadData();
    calculateSummaryValues();
  }

  @override
  void prepareForInsert() {
    isNewRecord = true;
    currentModel = createNewModel();
    _resetForm();
    Get.toNamed(Routes.lancamentoReceitaEditPage);
  }

  void _resetForm() {
    formWasChanged = false;
    contaReceitaModelController.text = '';
    metodoPagamentoModelController.text = '';
    dataReceitaController.date = null;
    valorController.updateValue(0);
    statusReceitaController.selected = 'Recebido';
    historicoController.text = '';
  }

  @override
  void selectRowForEditingById(int id) {
    final model = modelList.firstWhere((m) => m.id == id);
    currentModel = model.clone();
    updateControllersFromModel();
    Get.toNamed(Routes.lancamentoReceitaEditPage);
  }

  void updateControllersFromModel() {
    contaReceitaModelController.text = currentModel.contaReceitaModel?.descricao?.toString() ?? '';
    metodoPagamentoModelController.text = currentModel.metodoPagamentoModel?.descricao?.toString() ?? '';
    dataReceitaController.date = currentModel.dataReceita;
    valorController.updateValue(currentModel.valor ?? 0);
    statusReceitaController.selected = currentModel.statusReceita ?? 'Recebido';
    historicoController.text = currentModel.historico ?? '';
    formWasChanged = false;
  }

  @override
  Future<void> delete(Map<String, dynamic>? item) async {
    await super.delete(item);
    calculateSummaryValues();
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

    final result = await repository.save(lancamentoReceitaModel: currentModel);
    if (result == null) return;

    if (existingIndex >= 0) {
      modelList[existingIndex] = result;
    } else {
      modelList.insert(0, result);
    }

    if (!GetPlatform.isMobile) {
      updateGridRow(result);
    }

    await loadData();
    Get.back(result: true);
  }

  Future callContaReceitaLookup() async { 
		final lookupController = Get.find<LookupController>(); 
		lookupController.refreshItems(standardValue: '%'); 
		lookupController.title = '${'lookup_page_title'.tr} [Conta]'; 
		lookupController.route = '/conta-receita/'; 
		lookupController.gridColumns = contaReceitaGridColumns(isForLookup: true); 
		lookupController.aliasColumns = ContaReceitaModel.aliasColumns; 
		lookupController.dbColumns = ContaReceitaModel.dbColumns; 
		lookupController.standardColumn = ContaReceitaModel.aliasColumns[ContaReceitaModel.dbColumns.indexOf('descricao')]; 

		final plutoRowResult = await Get.toNamed(Routes.lookupPage); 
		if (plutoRowResult != null) { 
			currentModel.idContaReceita = plutoRowResult.cells['id']!.value; 
			currentModel.contaReceitaModel = ContaReceitaModel.fromPlutoRow(plutoRowResult); 
			contaReceitaModelController.text = currentModel.contaReceitaModel?.descricao ?? ''; 
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

  void showImportDataDialog() {
    Get.dialog(
      MonthYearPickerDialog(
        onConfirm: (selectedDate) async {
          await repository.transferDataFromOtherMonth(selectedDate, mesAno).then((data) async {
            await loadData();
          });
        },
      ),
    );
  }

  Future exportToCSV() async {
    await Util.exportToCSV(plutoGridStateManager.rows, plutoGridStateManager.columns, 'lancamentos_de_receita');
  }

  void calculateSummaryValues() {
    double tempAReceber = 0.0;
    double tempRecebido = 0.0;
    double tempTotal = 0.0;

    for (var lancamento in modelList) {
      if (lancamento.statusReceita == "A Receber") {
        tempAReceber += lancamento.valor ?? 0;
      } else if (lancamento.statusReceita == "Recebido") {
        tempRecebido += lancamento.valor ?? 0;
      }
      tempTotal += lancamento.valor ?? 0;
    }

    // Atualiza os valores observáveis
    aReceber = tempAReceber;
    recebido = tempRecebido;
    total = tempTotal;
  }

  @override
  void onInit() {
    mesAno = mesAno.isEmpty ? "${DateTime.now().month}/${DateTime.now().year}" : mesAno;
    super.onInit();
  }

  @override
  void onClose() {
    contaReceitaModelController.dispose();
    metodoPagamentoModelController.dispose();
    dataReceitaController.dispose();
    valorController.dispose();
    statusReceitaController.dispose();
    historicoController.dispose();
    super.onClose();
  }

}