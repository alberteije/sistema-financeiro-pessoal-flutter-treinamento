import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:financeiro_pessoal/app/infra/session.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/message_dialog.dart';

mixin ControllerBaseMixin<T> {
  // =======================================
  // Access control
  // =======================================
  bool canInsert = false;
  bool canUpdate = false;
  bool canDelete = false;
  String functionName = "";
  String screenTitle = "";

  void noPrivilegeMessage() {
    showNoPrivilegeSnackBar();
  }

  void setPrivilege() {
    /// You can create a table with all functions of the system and their access.
    /// The table would have the following fields:
    /// - functionName (funcaoNome in portuguese) = 'CUSTOMER' or 'VENDOR' - it should persist the name of the table
    /// - canInsert (podeInserir in portuguese) = it should persist 'Y' or 'N' ('Yes' in portuguese is 'Sim')
    /// - canUpdate (podeAlterar in portuguese) = it should persist 'Y' or 'N' ('Yes' in portuguese is 'Sim')
    /// - canDelete (podeExcluir in portuguese) = it should persist 'Y' or 'N' ('Yes' in portuguese is 'Sim')
    /// - idUser to know what user has those privileges
    /// Bellow we can see how to do this using a portuguese scheme. The logic is:
    /// --- if the user who logged in the system is an Administrator, then he/she canInsert, canUpdate and canDelete
    /// --- else then we will look at the functions that we have got from the serve to see if the user has those access
    /// This mixin will be used by controllers that will refresh insert, delete and update functions of the screen.

    canInsert = Session.loggedInUser.administrador == 'S' || Session.accessControlList.any((t) => t.funcaoNome?.toLowerCase() == functionName.toLowerCase() && t.podeInserir == 'S');

    canUpdate = Session.loggedInUser.administrador == 'S' || Session.accessControlList.any((t) => t.funcaoNome?.toLowerCase() == functionName.toLowerCase() && t.podeAlterar == 'S');

    canDelete = Session.loggedInUser.administrador == 'S' || Session.accessControlList.any((t) => t.funcaoNome?.toLowerCase() == functionName.toLowerCase() && t.podeExcluir == 'S');
  }

  // =======================================
  // Other requirements
  // =======================================

  // Common widgets
  final scrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final _formWasChanged = false.obs;
  bool get formWasChanged => _formWasChanged.value;
  set formWasChanged(value) => _formWasChanged.value = value;

  final _standardFieldForFilter = ''.obs;
  String get standardFieldForFilter => _standardFieldForFilter.value;
  set standardFieldForFilter(value) => _standardFieldForFilter.value = value;

  // PlutoGrid
  late PlutoGridStateManager _plutoGridStateManager;
  PlutoGridStateManager get plutoGridStateManager => _plutoGridStateManager;
  set plutoGridStateManager(value) => _plutoGridStateManager = value;

  // Filter
  final _filter = Filter().obs;
  Filter get filter => _filter.value;
  set filter(value) => _filter.value = value ?? Filter();

  void preventDataLoss() {
    if (formWasChanged) {
      showQuestionDialog('message_data_loss'.tr, () { Get.back();});
    } else {
      Get.back();
    }
  }

  // Abstracts Methods
  Future<void> getList({Filter? filter});
  Future<void> loadData();
  Future<void> callFilter();
  void prepareForInsert();
  void selectRowForEditing(PlutoRow? row);
  void selectRowForEditingById(int id);
  void editSelectedItem();
  Future<void> deleteSelected();
  Future<void> delete(Map<String, dynamic>? item);
  Future<void> save();
  void printReport();
}