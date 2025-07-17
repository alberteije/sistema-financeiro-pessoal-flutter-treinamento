import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';

import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/extrato_bancario_repository.dart';

class ExtratoBancarioController extends ControllerBase<ExtratoBancarioModel, ExtratoBancarioRepository> {

  ExtratoBancarioController({required super.repository}) {
    dbColumns = ExtratoBancarioModel.dbColumns;
    aliasColumns = ExtratoBancarioModel.aliasColumns;
    gridColumns = extratoBancarioGridColumns();
    functionName = "extrato_bancario";
    screenTitle = "Extrato Bancário";
  }

  @override
  ExtratoBancarioModel createNewModel() => ExtratoBancarioModel();

  @override
  final standardFieldForFilter = ExtratoBancarioModel.aliasColumns[ExtratoBancarioModel.dbColumns.indexOf('data_transacao')];

  final dataTransacaoController = DatePickerItemController(null);
  final idTransacaoController = TextEditingController();
  final checknumController = TextEditingController();
  final numeroReferenciaController = TextEditingController();
  final valorController = MoneyMaskedTextController();
  final historicoController = TextEditingController();
  final conciliadoController = CustomDropdownButtonController('Sim');

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['data_transacao'],
    'secondaryColumns': ['id_transacao'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((extratoBancario) => extratoBancario.toJson).toList();
  }

  @override
  void prepareForInsert() {
    isNewRecord = true;
    currentModel = createNewModel();
    _resetForm();
    Get.toNamed(Routes.extratoBancarioEditPage);
  }

  void _resetForm() {
    formWasChanged = false;
    dataTransacaoController.date = null;
    idTransacaoController.text = '';
    checknumController.text = '';
    numeroReferenciaController.text = '';
    valorController.updateValue(0);
    historicoController.text = '';
    conciliadoController.selected = 'Sim';
  }

  @override
  void selectRowForEditingById(int id) {
    final model = modelList.firstWhere((m) => m.id == id);
    currentModel = model.clone();
    updateControllersFromModel();
    Get.toNamed(Routes.extratoBancarioEditPage);
  }

  void updateControllersFromModel() {
    dataTransacaoController.date = currentModel.dataTransacao;
    idTransacaoController.text = currentModel.idTransacao ?? '';
    checknumController.text = currentModel.checknum ?? '';
    numeroReferenciaController.text = currentModel.numeroReferencia ?? '';
    valorController.updateValue(currentModel.valor ?? 0);
    historicoController.text = currentModel.historico ?? '';
    conciliadoController.selected = currentModel.conciliado ?? 'Sim';
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

    final result = await repository.save(extratoBancarioModel: currentModel);
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


  @override
  void onClose() {
    dataTransacaoController.dispose();
    idTransacaoController.dispose();
    checknumController.dispose();
    numeroReferenciaController.dispose();
    valorController.dispose();
    historicoController.dispose();
    conciliadoController.dispose();
    super.onClose();
  }

}