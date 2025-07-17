import 'package:get/get.dart';

import 'package:financeiro_pessoal/app/page/modules/resumo/summary_chart_dialog.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/resumo_repository.dart';

class ResumoController extends ControllerBase<ResumoModel, ResumoRepository> {

  ResumoController({required super.repository}) {
    dbColumns = ResumoModel.dbColumns;
    aliasColumns = ResumoModel.aliasColumns;
    gridColumns = resumoGridColumns();
    functionName = "resumo";
    screenTitle = "Resumo";
  }

  String mesAno = "";
  final RxBool hasChanges = false.obs;

  final _saldo = 0.0.obs;
  double get saldo => _saldo.value;
  set saldo(double value) => _saldo.value = value;

  @override
  ResumoModel createNewModel() => ResumoModel();

  @override
  final standardFieldForFilter = ResumoModel.aliasColumns[ResumoModel.dbColumns.indexOf('mes_ano')];

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['mes_ano'],
    'secondaryColumns': ['receita_despesa'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((resumo) => resumo.toJson).toList();
  }

  @override
  Future<void> getList({Filter? filter}) async {
    filter = Filter(field: 'mes_ano', value: mesAno.padLeft(7, '0'));
    await super.getList(filter: filter);
  }

  @override
  Future<void> loadData() async {
    await super.loadData();
    calculateSummaryValues();
  }

  @override
  void prepareForInsert() {}

  @override
  void selectRowForEditingById(int id) {}

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

    final result = await repository.save(resumoModel: currentModel);
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

  void markAsChanged() {
    hasChanges.value = true;
  }

  Future<void> doSummary() async {
    showQuestionDialog('Deseja processar o resumo?', () async {
      await repository.doSummary(mesAno.padLeft(7, '0')).then((data) async {
        await loadData();
      });
    });
  }

  Future<void> doCalculateValues() async {
    showQuestionDialog('Deseja calcular os valores do resumo?', () async {
      await saveChanges();
      final filter = Util.applyMonthYearToFilter(mesAno, Filter());
      await repository.calculateSummarryForAMonth(mesAno.padLeft(7, '0'), filter).then((data) async {
        await loadData();
      });

      calculateSummaryValues();
    });
  }

  void showSummaryChart() {
    Get.dialog(
			SummaryChartDialog(resumoList: modelList),
		);
  }

  Future<void> saveChanges() async {
    List<ResumoModel> resumoList = [];

    // Percorrer as linhas da PlutoGrid e converter para ResumoModel
    for (var row in plutoGridStateManager.rows) {
      final resumoModel = ResumoModel(
        id: row.cells['id']!.value,
        receitaDespesa: row.cells['receitaDespesa']!.value,
        codigo: row.cells['codigo']!.value,
        descricao: row.cells['descricao']!.value,
        valorOrcado: row.cells['valorOrcado']!.value,
        valorRealizado: row.cells['valorRealizado']!.value,
        mesAno: mesAno.padLeft(7, '0'),
      );

      // Adicionar na lista para salvar depois
      resumoList.add(resumoModel);
    }

    // Salvar todas as alterações no banco
    await repository.saveAll(resumoList);

    hasChanges.value = false;
  }

  void calculateSummaryValues() {
    double tempReceitas = 0.0;
    double tempDespesas = 0.0;

    for (var lancamento in modelList) {
      if (lancamento.descricao == "TOTAL RECEITAS") {
        tempReceitas = lancamento.valorRealizado ?? 0;
      } else if (lancamento.descricao == "TOTAL DESPESAS") {
        tempDespesas += lancamento.valorRealizado ?? 0;
      }
    }

    // Atualiza os valores observáveis
    saldo = tempReceitas - tempDespesas;
  }

  @override
  void onInit() {
    mesAno = mesAno.isEmpty ? "${DateTime.now().month}/${DateTime.now().year}" : mesAno;
    super.onInit();
  }
}