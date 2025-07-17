import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

import 'package:financeiro_pessoal/app/data/domain/domain_imports.dart';

class ResumoModel extends ModelBase {
  int? id;
  String? mesAno;
  String? receitaDespesa;
  String? codigo;
  String? descricao;
  double? valorOrcado;
  double? valorRealizado;
  double? diferenca;

  ResumoModel({
    this.id,
    this.mesAno,
    this.receitaDespesa = 'Receita',
    this.codigo,
    this.descricao,
    this.valorOrcado,
    this.valorRealizado,
    this.diferenca,
  });

  static List<String> dbColumns = <String>[
    'id',
    'mes_ano',
    'receita_despesa',
    'codigo',
    'descricao',
    'valor_orcado',
    'valor_realizado',
    'diferenca',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Mes Ano',
    'Receita Despesa',
    'Codigo',
    'Descricao',
    'Valor Orcado',
    'Valor Realizado',
    'Diferenca',
  ];

  ResumoModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    mesAno = jsonData['mesAno'];
    receitaDespesa = ResumoDomain.getReceitaDespesa(jsonData['receitaDespesa']);
    codigo = jsonData['codigo'];
    descricao = jsonData['descricao'];
    valorOrcado = jsonData['valorOrcado']?.toDouble();
    valorRealizado = jsonData['valorRealizado']?.toDouble();
    diferenca = jsonData['diferenca']?.toDouble();
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['mesAno'] = mesAno;
    jsonData['receitaDespesa'] = ResumoDomain.setReceitaDespesa(receitaDespesa);
    jsonData['codigo'] = codigo;
    jsonData['descricao'] = descricao;
    jsonData['valorOrcado'] = valorOrcado;
    jsonData['valorRealizado'] = valorRealizado;
    jsonData['diferenca'] = diferenca;

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static ResumoModel fromPlutoRow(PlutoRow row) {
    return ResumoModel(
      id: row.cells['id']?.value,
      mesAno: row.cells['mesAno']?.value,
      receitaDespesa: row.cells['receitaDespesa']?.value,
      codigo: row.cells['codigo']?.value,
      descricao: row.cells['descricao']?.value,
      valorOrcado: row.cells['valorOrcado']?.value,
      valorRealizado: row.cells['valorRealizado']?.value,
      diferenca: row.cells['diferenca']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'mesAno': PlutoCell(value: mesAno ?? ''),
        'receitaDespesa': PlutoCell(value: receitaDespesa ?? ''),
        'codigo': PlutoCell(value: codigo ?? ''),
        'descricao': PlutoCell(value: descricao ?? ''),
        'valorOrcado': PlutoCell(value: valorOrcado ?? 0.0),
        'valorRealizado': PlutoCell(value: valorRealizado ?? 0.0),
        'diferenca': PlutoCell(value: diferenca ?? 0.0),
      },
    );
  }

  ResumoModel clone() {
    return ResumoModel(
      id: id,
      mesAno: mesAno,
      receitaDespesa: receitaDespesa,
      codigo: codigo,
      descricao: descricao,
      valorOrcado: valorOrcado,
      valorRealizado: valorRealizado,
      diferenca: diferenca,
    );
  }


}