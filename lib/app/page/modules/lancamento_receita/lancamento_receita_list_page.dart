import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/shared_widget/input/input_imports.dart';
import 'package:financeiro_pessoal/app/controller/lancamento_receita_controller.dart';
import 'package:financeiro_pessoal/app/page/shared_page/list_page_base.dart';

class LancamentoReceitaListPage extends ListPageBase<LancamentoReceitaController> {
  const LancamentoReceitaListPage({Key? key}) : super(key: key);

  @override
  List<Map<String, dynamic>> get mobileItems => controller.mobileItems;

  @override
  Map<String, dynamic> get mobileConfig => controller.mobileConfig;

  @override
  String get standardFieldForFilter => controller.standardFieldForFilter;

  @override
  List<Widget> additionalAppBarActions() {
    return [
      IconButton(
        tooltip: 'Importar Lançamentos',
        icon: const Icon(Icons.sim_card_download_outlined),
        color: Colors.lime,
        onPressed: controller.showImportDataDialog,
      ),
      IconButton(
        tooltip: 'Exportar para Excel',
        icon: const Icon(Icons.dataset_outlined),
        color: Colors.amber,
        onPressed: controller.exportToCSV,
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
              "A Receber: ${Util.moneyFormat(controller.aReceber)}",
              style: const TextStyle(color: Colors.white),
            )),
            const SizedBox(width: 16),
            Obx(() => Text(
              "Recebido: ${Util.moneyFormat(controller.recebido)}",
              style: const TextStyle(color: Colors.white),
            )),
            const SizedBox(width: 16),
            Obx(() => Text(
              "Total: ${Util.moneyFormat(controller.total)}",
              style: const TextStyle(color: Colors.white),
            )),
          ],
        ),
      )
    );
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

}