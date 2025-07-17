import 'package:flutter/material.dart';
import 'package:financeiro_pessoal/app/controller/metodo_pagamento_controller.dart';
import 'package:financeiro_pessoal/app/page/shared_page/list_page_base.dart';

class MetodoPagamentoListPage extends ListPageBase<MetodoPagamentoController> {
  const MetodoPagamentoListPage({Key? key}) : super(key: key);

  @override
  List<Map<String, dynamic>> get mobileItems => controller.mobileItems;

  @override
  Map<String, dynamic> get mobileConfig => controller.mobileConfig;

  @override
  String get standardFieldForFilter => controller.standardFieldForFilter;
}