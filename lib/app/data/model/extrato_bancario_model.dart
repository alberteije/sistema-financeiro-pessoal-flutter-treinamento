import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

import 'package:financeiro_pessoal/app/infra/infra_imports.dart';
import 'package:intl/intl.dart';
import 'package:financeiro_pessoal/app/data/domain/domain_imports.dart';

class ExtratoBancarioModel extends ModelBase {
  int? id;
  DateTime? dataTransacao;
  String? idTransacao;
  String? checknum;
  String? numeroReferencia;
  double? valor;
  String? historico;
  String? conciliado;

  ExtratoBancarioModel({
    this.id,
    this.dataTransacao,
    this.idTransacao,
    this.checknum,
    this.numeroReferencia,
    this.valor,
    this.historico,
    this.conciliado = 'Sim',
  });

  static List<String> dbColumns = <String>[
    'id',
    'data_transacao',
    'id_transacao',
    'checknum',
    'numero_referencia',
    'valor',
    'historico',
    'conciliado',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Data Transacao',
    'Id Transacao',
    'Checknum',
    'Numero Referencia',
    'Valor',
    'Historico',
    'Conciliado',
  ];

  ExtratoBancarioModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    dataTransacao = jsonData['dataTransacao'] != null ? DateTime.tryParse(jsonData['dataTransacao']) : null;
    idTransacao = jsonData['idTransacao'];
    checknum = jsonData['checknum'];
    numeroReferencia = jsonData['numeroReferencia'];
    valor = jsonData['valor']?.toDouble();
    historico = jsonData['historico'];
    conciliado = ExtratoBancarioDomain.getConciliado(jsonData['conciliado']);
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['dataTransacao'] = dataTransacao != null ? DateFormat('yyyy-MM-ddT00:00:00').format(dataTransacao!) : null;
    jsonData['idTransacao'] = idTransacao;
    jsonData['checknum'] = checknum;
    jsonData['numeroReferencia'] = numeroReferencia;
    jsonData['valor'] = valor;
    jsonData['historico'] = historico;
    jsonData['conciliado'] = ExtratoBancarioDomain.setConciliado(conciliado);

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static ExtratoBancarioModel fromPlutoRow(PlutoRow row) {
    return ExtratoBancarioModel(
      id: row.cells['id']?.value,
      dataTransacao: Util.stringToDate(row.cells['dataTransacao']?.value),
      idTransacao: row.cells['idTransacao']?.value,
      checknum: row.cells['checknum']?.value,
      numeroReferencia: row.cells['numeroReferencia']?.value,
      valor: row.cells['valor']?.value,
      historico: row.cells['historico']?.value,
      conciliado: row.cells['conciliado']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'dataTransacao': PlutoCell(value: dataTransacao),
        'idTransacao': PlutoCell(value: idTransacao ?? ''),
        'checknum': PlutoCell(value: checknum ?? ''),
        'numeroReferencia': PlutoCell(value: numeroReferencia ?? ''),
        'valor': PlutoCell(value: valor ?? 0.0),
        'historico': PlutoCell(value: historico ?? ''),
        'conciliado': PlutoCell(value: conciliado ?? ''),
      },
    );
  }

  ExtratoBancarioModel clone() {
    return ExtratoBancarioModel(
      id: id,
      dataTransacao: dataTransacao,
      idTransacao: idTransacao,
      checknum: checknum,
      numeroReferencia: numeroReferencia,
      valor: valor,
      historico: historico,
      conciliado: conciliado,
    );
  }


}