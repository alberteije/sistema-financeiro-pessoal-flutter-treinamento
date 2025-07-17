import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:intl/intl.dart';
import 'package:financeiro_pessoal/app/data/domain/domain_imports.dart';

class LancamentoReceitaModel extends ModelBase {
  int? id;
  int? idContaReceita;
  int? idMetodoPagamento;
  DateTime? dataReceita;
  double? valor;
  String? statusReceita;
  String? historico;
  ContaReceitaModel? contaReceitaModel;
  MetodoPagamentoModel? metodoPagamentoModel;

  LancamentoReceitaModel({
    this.id,
    this.idContaReceita,
    this.idMetodoPagamento,
    this.dataReceita,
    this.valor,
    this.statusReceita = 'Recebido',
    this.historico,
    ContaReceitaModel? contaReceitaModel,
    MetodoPagamentoModel? metodoPagamentoModel,
  }) {
    this.contaReceitaModel = contaReceitaModel ?? ContaReceitaModel();
    this.metodoPagamentoModel = metodoPagamentoModel ?? MetodoPagamentoModel();
  }

  static List<String> dbColumns = <String>[
    'id',
    'data_receita',
    'valor',
    'status_receita',
    'historico',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Data Receita',
    'Valor',
    'Status Receita',
    'Historico',
  ];

  LancamentoReceitaModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    idContaReceita = jsonData['idContaReceita'];
    idMetodoPagamento = jsonData['idMetodoPagamento'];
    dataReceita = jsonData['dataReceita'] != null ? DateTime.tryParse(jsonData['dataReceita']) : null;
    valor = jsonData['valor']?.toDouble();
    statusReceita = LancamentoReceitaDomain.getStatusReceita(jsonData['statusReceita']);
    historico = jsonData['historico'];
    contaReceitaModel = jsonData['contaReceitaModel'] == null ? ContaReceitaModel() : ContaReceitaModel.fromJson(jsonData['contaReceitaModel']);
    metodoPagamentoModel = jsonData['metodoPagamentoModel'] == null ? MetodoPagamentoModel() : MetodoPagamentoModel.fromJson(jsonData['metodoPagamentoModel']);
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['idContaReceita'] = idContaReceita != 0 ? idContaReceita : null;
    jsonData['idMetodoPagamento'] = idMetodoPagamento != 0 ? idMetodoPagamento : null;
    jsonData['dataReceita'] = dataReceita != null ? DateFormat('yyyy-MM-ddT00:00:00').format(dataReceita!) : null;
    jsonData['valor'] = valor;
    jsonData['statusReceita'] = LancamentoReceitaDomain.setStatusReceita(statusReceita);
    jsonData['historico'] = historico;
    jsonData['contaReceitaModel'] = contaReceitaModel?.toJson;
    jsonData['contaReceita'] = contaReceitaModel?.descricao ?? '';
    jsonData['metodoPagamentoModel'] = metodoPagamentoModel?.toJson;
    jsonData['metodoPagamento'] = metodoPagamentoModel?.descricao ?? '';

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static LancamentoReceitaModel fromPlutoRow(PlutoRow row) {
    return LancamentoReceitaModel(
      id: row.cells['id']?.value,
      idContaReceita: row.cells['idContaReceita']?.value,
      idMetodoPagamento: row.cells['idMetodoPagamento']?.value,
      dataReceita: Util.stringToDate(row.cells['dataReceita']?.value),
      valor: row.cells['valor']?.value,
      statusReceita: row.cells['statusReceita']?.value,
      historico: row.cells['historico']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'idContaReceita': PlutoCell(value: idContaReceita ?? 0),
        'idMetodoPagamento': PlutoCell(value: idMetodoPagamento ?? 0),
        'dataReceita': PlutoCell(value: dataReceita),
        'valor': PlutoCell(value: valor ?? 0.0),
        'statusReceita': PlutoCell(value: statusReceita ?? ''),
        'historico': PlutoCell(value: historico ?? ''),
        'contaReceita': PlutoCell(value: contaReceitaModel?.descricao ?? ''),
        'metodoPagamento': PlutoCell(value: metodoPagamentoModel?.descricao ?? ''),
      },
    );
  }

  LancamentoReceitaModel clone() {
    return LancamentoReceitaModel(
      id: id,
      idContaReceita: idContaReceita,
      idMetodoPagamento: idMetodoPagamento,
      dataReceita: dataReceita,
      valor: valor,
      statusReceita: statusReceita,
      historico: historico,
      contaReceitaModel: contaReceitaModel?.clone(),
      metodoPagamentoModel: metodoPagamentoModel?.clone(),
    );
  }


}