// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart' as xml;

import 'package:financeiro_pessoal/app/page/shared_widget/shared_widget_imports.dart';
import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:financeiro_pessoal/app/page/grid_columns/grid_columns_imports.dart';
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

  String mesAno = "";

  final _creditos = 0.0.obs;
  double get creditos => _creditos.value;
  set creditos(double value) => _creditos.value = value;

  final _debitos = 0.0.obs;
  double get debitos => _debitos.value;
  set debitos(double value) => _debitos.value = value;

  final _saldo = 0.0.obs;
  double get saldo => _saldo.value;
  set saldo(double value) => _saldo.value = value;

  @override
  ExtratoBancarioModel createNewModel() => ExtratoBancarioModel();

  @override
  final standardFieldForFilter = ExtratoBancarioModel.aliasColumns[ExtratoBancarioModel.dbColumns.indexOf('data_transacao')];

  final Map<String, dynamic> mobileConfig = {
    'primaryColumns': ['data_transacao'],
    'secondaryColumns': ['id_transacao'],
  };

  List<Map<String, dynamic>> get mobileItems {
    return modelList.map((extratoBancario) => extratoBancario.toJson).toList();
  }

  @override
  Future<void> getList({Filter? filter}) async {
    filter = Util.applyMonthYearToFilter(mesAno, filter ?? Filter());
    await super.getList(filter: filter);
  }

  @override
  Future<void> loadData() async {
    await super.loadData();
    calculateSummaryValues();
  }

  @override
  void prepareForInsert() {}

  @override
  void selectRowForEditingById(int id) {}

  @override
  Future<void> save() async {}

  Future<void> importOfx() async {
    showQuestionDialog('Deseja importar o arquivo do extrato bancário (Formato OFX)?', () async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          String arquivoOFX;

          if (kIsWeb) {
            // Flutter Web -> Lê o conteúdo a partir de `bytes`
            Uint8List fileBytes = result.files.single.bytes!;
            arquivoOFX = utf8.decode(fileBytes);
          } else {
            // Flutter Desktop -> Usa `path`
            File file = File(result.files.single.path!);
            arquivoOFX = await file.readAsString();
          }

          final arquivoXML = xml.XmlDocument.parse(arquivoOFX);

          // Limpa a lista
          modelList.clear();

          // Exclui os registros atuais do banco
          await repository.deleteByDateRange(filter);

          // Captura os lançamentos no arquivo
          final lancamentos = arquivoXML.findAllElements('STMTTRN');
          for (var lancamento in lancamentos) {
            var extrato = ExtratoBancarioModel();
            extrato.id = null;
            final ano = int.parse(lancamento.getElement('DTPOSTED')?.text.substring(0, 4) ?? '');
            final mes = int.parse(lancamento.getElement('DTPOSTED')?.text.substring(4, 6) ?? '');
            final dia = int.parse(lancamento.getElement('DTPOSTED')?.text.substring(6, 8) ?? '');

            String mesAnoExtrato = "$mes/$ano";
            if (mesAno != mesAnoExtrato) {
              showErrorSnackBar(message: "Existem lançamentos no extrato que estão fora do mês selecionado.");
              return;
            }

            extrato.dataTransacao = DateTime(ano, mes, dia);
            extrato.idTransacao = lancamento.getElement('FITID')?.text;
            extrato.checknum = lancamento.getElement('CHECKNUM')?.text;
            extrato.numeroReferencia = lancamento.getElement('REFNUM')?.text;
            extrato.valor = double.tryParse(lancamento.getElement('TRNAMT')?.text ?? "0");
            extrato.historico = lancamento.getElement('MEMO')?.text;

            // Persiste no banco de dados
            final savedExtrato = await repository.save(extratoBancarioModel: extrato);
            if (savedExtrato != null) {
              modelList.add(savedExtrato);
            }
          }
          await loadData();
        } else {
          showInfoSnackBar(message: "Nenhum arquivo selecionado.");
        }
      } catch (e) {
        showErrorSnackBar(message: "Erro ao importar extrato: ${e.toString()}");
      }
    });
  }

  Future<void> reconcileTransactions() async {
    showQuestionDialog('Deseja conciliar os lançamentos?', () async {
      await repository.reconcileTransactions(filter).then((value) async {
        await loadData();
      });
    });
  }

  Future<void> exportDataToIncomesAndExpenses() async {
    showQuestionDialog('Deseja exportar os dados para Lançamentos de Receita e Despesa?', () async {
      await repository.exportDataToIncomesAndExpenses(filter);
    });
  }

  void calculateSummaryValues() {
    double tempCreditos = 0.0;
    double tempDebitos = 0.0;
    double tempSaldo = 0.0;

    for (var lancamento in modelList) {
      lancamento.valor = lancamento.valor ?? 0;
      if (lancamento.valor! >= 0) {
        tempCreditos += lancamento.valor ?? 0;
      } else {
        tempDebitos += lancamento.valor ?? 0;
      }
      tempSaldo += lancamento.valor ?? 0;
    }

    // Atualiza os valores observáveis
    creditos = tempCreditos;
    debitos = tempDebitos;
    saldo = tempSaldo;
  }

  @override
  void onInit() {
    mesAno = mesAno.isEmpty ? "${DateTime.now().month}/${DateTime.now().year}" : mesAno;
    super.onInit();
  }

}