import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/responsive_list_view.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';
import 'package:financeiro_pessoal/app/controller/controller_base.dart';

abstract class ListPageBase<T extends ControllerBase> extends GetView<T> {
  const ListPageBase({Key? key}) : super(key: key);

  List<Map<String, dynamic>> get mobileItems;
  Map<String, dynamic> get mobileConfig;
  String get standardFieldForFilter;

  List<Widget>? additionalAppBarActions() => null;
  List<Widget>? additionalBottomActions() => null;
  List<Widget>? additionalMobileActions() => null;
  Widget? buildAdditionalContentTop() => null;
  Widget? buildAdditionalContentBottom() => null;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GetPlatform.isMobile && controller.modelList.isEmpty) {
        controller.keyboardListener = null;
        controller.loadData();
      }
    });

    return Obx(() {
      if (GetPlatform.isMobile & Constants.enableMobileLayout) {
        return buildMobileView();
      } else {
        return buildDesktopView();
      }
    });
  }

  Widget buildMobileView() {
    final additionalContentTop = buildAdditionalContentTop();
    final additionalContentBottom = buildAdditionalContentBottom();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(controller.screenTitle),
        actions: [
          ...?additionalMobileActions(),
          exitButton(),
        ],
      ),
      body: Column(
        children: [
          if (additionalContentTop != null) additionalContentTop,
          Expanded(
            child: ResponsiveListView(
              items: mobileItems,
              primaryColumns: mobileConfig['primaryColumns'],
              secondaryColumns: mobileConfig['secondaryColumns'],
              onItemTap: (item) => controller.selectRowForEditingById(item['id']),
              onDelete: (item) => controller.delete(item),
            ),
          ),
          if (additionalContentBottom != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: additionalContentBottom,
            ),
        ],
      ),
      floatingActionButton: controller.canInsert
          ? FloatingActionButton(
              onPressed: controller.prepareForInsert,
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black26,
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: controller.printReport,
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => controller.callFilter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopView() {
    final additionalContentTop = buildAdditionalContentTop();
    final additionalContentBottom = buildAdditionalContentBottom();

    return Scaffold(
      appBar: appBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.canInsert ? controller.prepareForInsert : controller.noPrivilegeMessage,
        child: iconButtonInsert(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black26,
        shape: const CircularNotchedRectangle(),
        child: Row(children: [
          ...standardBottomActions(),
          ...?additionalBottomActions(),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            if (additionalContentTop != null) additionalContentTop,
            Expanded(
              child: PlutoGrid(
                configuration: gridConfiguration(),
                noRowsWidget: controller.isLoading.value ? const Center(child: CircularProgressIndicator()) : Text('grid_no_rows'.tr),
                createFooter: (stateManager) {
                  stateManager.setPageSize(Constants.gridRowsPerPage, notify: false);
                  return PlutoPagination(stateManager);
                },
                columns: controller.gridColumns,
                rows: controller.plutoRows(),
                onLoaded: (event) {
                  controller.plutoGridStateManager = event.stateManager;
                  controller.plutoGridStateManager.setSelectingMode(PlutoGridSelectingMode.row);
                  controller.keyboardListener = controller.plutoGridStateManager.keyManager!.subject.stream.listen(controller.handleKeyboard);
                  controller.loadData();
                },
                mode: PlutoGridMode.selectWithOneTap,
              ),
            ),
            if (additionalContentBottom != null) additionalContentBottom,
          ],
        ),
      ),
    );
  }

  List<Widget> standardAppBarActions() {
    return [
      editButton(onPressed: controller.canUpdate ? controller.editSelectedItem : controller.noPrivilegeMessage),
      deleteButton(onPressed: controller.canDelete ? controller.deleteSelected : controller.noPrivilegeMessage),
      exitButton(),
      const SizedBox(
        height: 10,
        width: 5,
      ),
    ];
  }

  List<Widget> standardBottomActions() {
    return [
      printButton(onPressed: controller.printReport),
      filterButton(
        onPressed: () => controller.callFilter(),
      ),
    ];
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(controller.screenTitle),
      actions: [
        ...?additionalAppBarActions(),
        ...standardAppBarActions(),
      ],
    );
  }

}
