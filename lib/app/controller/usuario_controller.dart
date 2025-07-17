import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/data/repository/usuario_repository.dart';

class UsuarioController extends ControllerBase<UsuarioModel, UsuarioRepository> {

  UsuarioController({required super.repository}) {
    dbColumns = UsuarioModel.dbColumns;
    aliasColumns = UsuarioModel.aliasColumns;
    gridColumns = usuarioGridColumns();
    functionName = "usuario";
    screenTitle = "Usuário";
  }

  @override
  UsuarioModel createNewModel() => UsuarioModel();

  @override
  final standardFieldForFilter = UsuarioModel.aliasColumns[UsuarioModel.dbColumns.indexOf('login')];

  final loginController = TextEditingController();
  final senhaController = TextEditingController();

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['login'],
    'secondaryColumns': ['senha'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((usuario) => usuario.toJson).toList();
  }

  @override
  void prepareForInsert() {
    isNewRecord = true;
    currentModel = createNewModel();
    _resetForm();
    Get.toNamed(Routes.usuarioEditPage);
  }

  void _resetForm() {
    formWasChanged = false;
    loginController.text = '';
    senhaController.text = '';
  }

  @override
  void selectRowForEditingById(int id) {
    final model = modelList.firstWhere((m) => m.id == id);
    currentModel = model.clone();
    updateControllersFromModel();
    Get.toNamed(Routes.usuarioEditPage);
  }

  void updateControllersFromModel() {
    loginController.text = currentModel.login ?? '';
    senhaController.text = currentModel.senha ?? '';
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

    final result = await repository.save(usuarioModel: currentModel);
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

  Future<bool> doLogin({required String user, required String password}) async {
    return await repository.doLogin(user, password);
  }

  Future<bool> hasUsersInDatabase () async {
    final result = await repository.getList();
    return result.isNotEmpty;
  }

  @override
  void onClose() {
    loginController.dispose();
    senhaController.dispose();
    super.onClose();
  }

}