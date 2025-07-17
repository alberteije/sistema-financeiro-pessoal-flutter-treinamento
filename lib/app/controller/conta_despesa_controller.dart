import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/conta_despesa_repository.dart';

class ContaDespesaController extends ControllerBase<ContaDespesaModel, ContaDespesaRepository> {

  ContaDespesaController({required super.repository}) {
    dbColumns = ContaDespesaModel.dbColumns;
    aliasColumns = ContaDespesaModel.aliasColumns;
    gridColumns = contaDespesaGridColumns();
    functionName = "conta_despesa";
    screenTitle = "Contas de Despesa";
  }

  @override
  ContaDespesaModel createNewModel() => ContaDespesaModel();

  @override
  final standardFieldForFilter = ContaDespesaModel.aliasColumns[ContaDespesaModel.dbColumns.indexOf('codigo')];

  final codigoController = TextEditingController();
  final descricaoController = TextEditingController();

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['codigo'],
    'secondaryColumns': ['descricao'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((contaDespesa) => contaDespesa.toJson).toList();
  }

  @override
  void prepareForInsert() {
    isNewRecord = true;
    currentModel = createNewModel();
    _resetForm();
    Get.toNamed(Routes.contaDespesaEditPage);
  }

  void _resetForm() {
    formWasChanged = false;
    codigoController.text = '';
    descricaoController.text = '';
  }

  @override
  void selectRowForEditingById(int id) {
    final model = modelList.firstWhere((m) => m.id == id);
    currentModel = model.clone();
    updateControllersFromModel();
    Get.toNamed(Routes.contaDespesaEditPage);
  }

  void updateControllersFromModel() {
    codigoController.text = currentModel.codigo ?? '';
    descricaoController.text = currentModel.descricao ?? '';
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

    final result = await repository.save(contaDespesaModel: currentModel);
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
    codigoController.dispose();
    descricaoController.dispose();
    super.onClose();
  }

}