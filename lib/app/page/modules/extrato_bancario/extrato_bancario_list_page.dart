import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';
import 'package:financeiro_pessoal/app/controller/extrato_bancario_controller.dart';
import 'package:financeiro_pessoal/app/page/shared_page/list_page_base.dart';

class ExtratoBancarioListPage extends ListPageBase<ExtratoBancarioController> {
  const ExtratoBancarioListPage({Key? key}) : super(key: key);

  @override
  List<Map<String, dynamic>> get mobileItems => controller.mobileItems;

  @override
  Map<String, dynamic> get mobileConfig => controller.mobileConfig;

  @override
  String get standardFieldForFilter => controller.standardFieldForFilter;

  @override
  Widget buildMobileView() {
    return buildDesktopView();
  }

  @override
  Widget buildDesktopView() {
    final additionalContentBottom = buildAdditionalContentBottom();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(controller.screenTitle),
        actions: [
          ...additionalAppBarActions(),
          exitButton(),
          const SizedBox(
            height: 10,
            width: 5,
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black26,
        shape: const CircularNotchedRectangle(),
        child: Row(children: [
          ...additionalBottomActions(),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: PlutoGrid(
                configuration: gridConfiguration(),
                noRowsWidget: Text('grid_no_rows'.tr),
                columns: controller.gridColumns,
                rows: controller.plutoRows(),
                onLoaded: (event) {
                  controller.plutoGridStateManager = event.stateManager;
                  controller.plutoGridStateManager.setSelectingMode(PlutoGridSelectingMode.row);
                  controller.keyboardListener = controller.plutoGridStateManager.keyManager!.subject.stream.listen(controller.handleKeyboard);
                  controller.loadData();
                },
              ),
            ),
            additionalContentBottom,
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> additionalAppBarActions() {
    return [
      IconButton(
        tooltip: 'Importar Extrato OFX',
        icon: const Icon(Icons.attach_money_outlined),
        color: Colors.lime,
        onPressed: controller.importOfx,
      ),
      IconButton(
        tooltip: 'Conciliar Dados',
        icon: const Icon(Icons.check_box_outlined),
        color: Colors.amber,
        onPressed: controller.reconcileTransactions,
      ),
      IconButton(
        tooltip: 'Exportar como Lançamento',
        icon: const Icon(Icons.upload),
        color: Colors.lightGreen,
        onPressed: controller.exportDataToIncomesAndExpenses,
      ),
    ];
  }

  @override
  List<Widget> additionalBottomActions() {
    return [
      MonthYearPicker(
        onChanged: (month, year) async {
          controller.mesAno = "$month/$year";
          await controller.loadData();
        },
      ),
    ];
  }

  @override
  Widget buildAdditionalContentBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      color: Colors.black, 
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
              "Créditos: ${Util.moneyFormat(controller.creditos)}",
              style: const TextStyle(color: Colors.white),
            )),
            const SizedBox(width: 16),
            Obx(() => Text(
              "Débitos: ${Util.moneyFormat(controller.debitos)}",
              style: const TextStyle(color: Colors.white),
            )),
            const SizedBox(width: 16),
            Obx(() => Text(
              "Saldo: ${Util.moneyFormat(controller.saldo)}",
              style: const TextStyle(color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}