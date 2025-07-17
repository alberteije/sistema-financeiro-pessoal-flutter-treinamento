import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';


class ContaDespesaModel extends ModelBase {
  int? id;
  String? codigo;
  String? descricao;

  ContaDespesaModel({
    this.id,
    this.codigo,
    this.descricao,
  });

  static List<String> dbColumns = <String>[
    'id',
    'codigo',
    'descricao',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Codigo',
    'Descricao',
  ];

  ContaDespesaModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    codigo = jsonData['codigo'];
    descricao = jsonData['descricao'];
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['codigo'] = codigo;
    jsonData['descricao'] = descricao;

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static ContaDespesaModel fromPlutoRow(PlutoRow row) {
    return ContaDespesaModel(
      id: row.cells['id']?.value,
      codigo: row.cells['codigo']?.value,
      descricao: row.cells['descricao']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'codigo': PlutoCell(value: codigo ?? ''),
        'descricao': PlutoCell(value: descricao ?? ''),
      },
    );
  }

  ContaDespesaModel clone() {
    return ContaDespesaModel(
      id: id,
      codigo: codigo,
      descricao: descricao,
    );
  }


}