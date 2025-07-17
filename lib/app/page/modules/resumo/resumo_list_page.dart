import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_page/list_page_base.dart';
import 'package:financeiro_pessoal/app/controller/resumo_controller.dart';

class ResumoListPage extends ListPageBase<ResumoController> {
  const ResumoListPage({Key? key}) : super(key: key);

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
                onChanged: (PlutoGridOnChangedEvent event) {
                  controller.markAsChanged();
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
        tooltip: 'Processar Resumo',
        icon: const Icon(Icons.attach_money_outlined),
        color: Colors.lime,
        onPressed: controller.doSummary,
      ),
      IconButton(
        tooltip: 'Calcular Valores',
        icon: const Icon(Icons.calculate),
        color: Colors.lime,
        onPressed: controller.doCalculateValues,
      ),
      Obx(() => IconButton(
        tooltip: 'Salvar',
        icon: const Icon(Icons.save),
        color: controller.hasChanges.value ? Colors.orange : Colors.grey,
        onPressed: controller.hasChanges.value ? controller.saveChanges : null,
      )),
      const SizedBox(width: 20,),
      IconButton(
        tooltip: 'Gráfico do Resumo',
        icon: const Icon(Icons.bar_chart),
        color: Colors.blue,
        onPressed: controller.showSummaryChart,
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
      color: Colors.black, // Define um fundo para destacar os valores
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown, // Ajusta o tamanho automaticamente
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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