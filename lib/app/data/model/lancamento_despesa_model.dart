import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:intl/intl.dart';
import 'package:financeiro_pessoal/app/data/domain/domain_imports.dart';

class LancamentoDespesaModel extends ModelBase {
  int? id;
  int? idContaDespesa;
  int? idMetodoPagamento;
  DateTime? dataDespesa;
  double? valor;
  String? statusDespesa;
  String? historico;
  ContaDespesaModel? contaDespesaModel;
  MetodoPagamentoModel? metodoPagamentoModel;

  LancamentoDespesaModel({
    this.id,
    this.idContaDespesa,
    this.idMetodoPagamento,
    this.dataDespesa,
    this.valor,
    this.statusDespesa = 'Pago',
    this.historico,
    ContaDespesaModel? contaDespesaModel,
    MetodoPagamentoModel? metodoPagamentoModel,
  }) {
    this.contaDespesaModel = contaDespesaModel ?? ContaDespesaModel();
    this.metodoPagamentoModel = metodoPagamentoModel ?? MetodoPagamentoModel();
  }

  static List<String> dbColumns = <String>[
    'id',
    'data_despesa',
    'valor',
    'status_despesa',
    'historico',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Data Despesa',
    'Valor',
    'Status Despesa',
    'Historico',
  ];

  LancamentoDespesaModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    idContaDespesa = jsonData['idContaDespesa'];
    idMetodoPagamento = jsonData['idMetodoPagamento'];
    dataDespesa = jsonData['dataDespesa'] != null ? DateTime.tryParse(jsonData['dataDespesa']) : null;
    valor = jsonData['valor']?.toDouble();
    statusDespesa = LancamentoDespesaDomain.getStatusDespesa(jsonData['statusDespesa']);
    historico = jsonData['historico'];
    contaDespesaModel = jsonData['contaDespesaModel'] == null ? ContaDespesaModel() : ContaDespesaModel.fromJson(jsonData['contaDespesaModel']);
    metodoPagamentoModel = jsonData['metodoPagamentoModel'] == null ? MetodoPagamentoModel() : MetodoPagamentoModel.fromJson(jsonData['metodoPagamentoModel']);
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['idContaDespesa'] = idContaDespesa != 0 ? idContaDespesa : null;
    jsonData['idMetodoPagamento'] = idMetodoPagamento != 0 ? idMetodoPagamento : null;
    jsonData['dataDespesa'] = dataDespesa != null ? DateFormat('yyyy-MM-ddT00:00:00').format(dataDespesa!) : null;
    jsonData['valor'] = valor;
    jsonData['statusDespesa'] = LancamentoDespesaDomain.setStatusDespesa(statusDespesa);
    jsonData['historico'] = historico;
    jsonData['contaDespesaModel'] = contaDespesaModel?.toJson;
    jsonData['contaDespesa'] = contaDespesaModel?.descricao ?? '';
    jsonData['metodoPagamentoModel'] = metodoPagamentoModel?.toJson;
    jsonData['metodoPagamento'] = metodoPagamentoModel?.descricao ?? '';

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static LancamentoDespesaModel fromPlutoRow(PlutoRow row) {
    return LancamentoDespesaModel(
      id: row.cells['id']?.value,
      idContaDespesa: row.cells['idContaDespesa']?.value,
      idMetodoPagamento: row.cells['idMetodoPagamento']?.value,
      dataDespesa: Util.stringToDate(row.cells['dataDespesa']?.value),
      valor: row.cells['valor']?.value,
      statusDespesa: row.cells['statusDespesa']?.value,
      historico: row.cells['historico']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'idContaDespesa': PlutoCell(value: idContaDespesa ?? 0),
        'idMetodoPagamento': PlutoCell(value: idMetodoPagamento ?? 0),
        'dataDespesa': PlutoCell(value: dataDespesa),
        'valor': PlutoCell(value: valor ?? 0.0),
        'statusDespesa': PlutoCell(value: statusDespesa ?? ''),
        'historico': PlutoCell(value: historico ?? ''),
        'contaDespesa': PlutoCell(value: contaDespesaModel?.descricao ?? ''),
        'metodoPagamento': PlutoCell(value: metodoPagamentoModel?.descricao ?? ''),
      },
    );
  }

  LancamentoDespesaModel clone() {
    return LancamentoDespesaModel(
      id: id,
      idContaDespesa: idContaDespesa,
      idMetodoPagamento: idMetodoPagamento,
      dataDespesa: dataDespesa,
      valor: valor,
      statusDespesa: statusDespesa,
      historico: historico,
      contaDespesaModel: contaDespesaModel?.clone(),
      metodoPagamentoModel: metodoPagamentoModel?.clone(),
    );
  }


}