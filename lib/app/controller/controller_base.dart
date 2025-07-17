import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/controller/controller_imports.dart';
import 'package:financeiro_pessoal/app/mixin/controller_base_mixin.dart';
import 'package:financeiro_pessoal/app/routes/app_routes.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_page/shared_page_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';

abstract class ControllerBase<M, R> extends GetxController with ControllerBaseMixin<M> {

  ControllerBase({required this.repository}) {
    _currentModel = Rx<M>(createNewModel());
  }

  M createNewModel();

  final R repository;
  List<String> dbColumns = [];
  List<String> aliasColumns = [];
  List<PlutoColumn> gridColumns = [];

  late final Rx<M> _currentModel;
  M get currentModel => _currentModel.value;
  set currentModel(M? value) => _currentModel.value = value ?? createNewModel();

  final _modelList = <M>[].obs;
  List<M> get modelList => _modelList;

  late StreamSubscription? _keyboardListener;
  get keyboardListener => _keyboardListener;
  set keyboardListener(value) => _keyboardListener = value;

  final _isNewRecord = true.obs;
  bool get isNewRecord => _isNewRecord.value;
  set isNewRecord(value) => _isNewRecord.value = value;

  final isLoading = false.obs;

  List<PlutoRow> plutoRows() => List<PlutoRow>.from(
    modelList.map((model) => (model as dynamic).toPlutoRow())
  );

  @override
  Future<void> getList({Filter? filter}) async {
    await (repository as dynamic).getList(filter: filter).then((data) {
      final convertedData = data.cast<M>();
      modelList.assignAll(convertedData);
    });
  }

  @override
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await getList(filter: filter);
      if (!GetPlatform.isMobile) {
        plutoGridStateManager.setShowLoading(true);
        plutoGridStateManager.removeAllRows();
        plutoGridStateManager.appendRows(plutoRows());
        plutoGridStateManager.setShowLoading(false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> callFilter() async {
    final filterController = Get.find<FilterController>();
    filterController.title = '${'filter_page_title'.tr} [$screenTitle]';
    filterController.standardFilter = true;
    filterController.aliasColumns = aliasColumns;
    filterController.dbColumns = dbColumns;
    filterController.filter.field = standardFieldForFilter;
    filterController.fieldController.value = standardFieldForFilter;

    filter = await Get.toNamed(Routes.filterPage);
    await loadData();
  }

  @override
  void selectRowForEditing(PlutoRow? row) async {
    if (row == null) {
      showInfoSnackBar(message: 'message_select_one_to_edited'.tr);
      return;
    }

    isNewRecord = false;
    selectRowForEditingById(row.cells['id']?.value);
  }

  @override
  void editSelectedItem() {
    selectRowForEditing(plutoGridStateManager.currentRow);
  }

  @override
  Future<void> deleteSelected() async {
    await delete(null);
  }

  @override
  Future<void> delete(Map<String, dynamic>? item) async {
    final id = _extractIdToDelete(item);
    if (id == null) return;

    showDeleteDialog(() async {
      if (!await _performDeletion(id)) return;
      _handlePostDeletion(item, id);
    });
  }

  int? _extractIdToDelete(Map<String, dynamic>? item) {
    if (item != null) return item['id'];

    final currentRow = plutoGridStateManager.currentRow;
    if (currentRow == null) {
      showInfoSnackBar(message: 'message_select_one_to_delete'.tr);
      return null;
    }
    return currentRow.cells['id']?.value;
  }

  Future<bool> _performDeletion(int id) async {
    final success = await (repository as dynamic).delete(id: id);
    if (!success) showErrorSnackBar(message: 'message_error_delete'.tr);
    return success;
  }

  void _handlePostDeletion(Map<String, dynamic>? item, int id) {
    modelList.removeWhere((t) => (t as dynamic).id == id);

    if (item == null) {
      plutoGridStateManager.removeCurrentRow();
    } else {
      update();
    }
  }

  void updateGridRow(M model) {
    final newRow = (model as dynamic).toPlutoRow();
    final index = plutoGridStateManager.rows.indexWhere(
      (row) => row.cells['id']?.value == (model as dynamic).id
    );

    if (index >= 0) {
      final row = plutoGridStateManager.rows[index];
      newRow.cells.forEach((key, newCell) {
        if (row.cells[key] != null) {
          row.cells[key]!.value = newCell.value;
        }
      });
    } else {
      plutoGridStateManager.prependRows([newRow]);
    }
  }

  @override
  void printReport() {
    Get.to(() => ReportPage(
      columns: gridColumns.map((column) => column.title).toList(),
      plutoRows: plutoRows(),
      title: screenTitle,
    ));
  }

  void handleKeyboard(PlutoKeyManagerEvent event) {
    if (event.isKeyDownEvent && event.event.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
      if (canUpdate) {
        selectRowForEditing(plutoGridStateManager.currentRow);
      } else {
        noPrivilegeMessage();
      }
    }
  }

  @override
  void onInit() {
    bootstrapGridParameters(
      gutterSize: Constants.flutterBootstrapGutterSize,
    );
    setPrivilege();
    super.onInit();
  }

  @override
  void onClose() {
    if (_keyboardListener != null) {
      _keyboardListener!.cancel();
      _keyboardListener = null;
    }
    scrollController.dispose();
    super.onClose();
  }
}