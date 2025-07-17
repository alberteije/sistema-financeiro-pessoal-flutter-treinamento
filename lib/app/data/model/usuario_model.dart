import 'dart:convert';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';


class UsuarioModel extends ModelBase {
  int? id;
  String? login;
  String? senha;

  UsuarioModel({
    this.id,
    this.login,
    this.senha,
  });

  static List<String> dbColumns = <String>[
    'id',
    'login',
    'senha',
  ];

  static List<String> aliasColumns = <String>[
    'Id',
    'Login',
    'Senha',
  ];

  UsuarioModel.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    login = jsonData['login'];
    senha = jsonData['senha'];
  }

  Map<String, dynamic> get toJson {
    Map<String, dynamic> jsonData = <String, dynamic>{};

    jsonData['id'] = id != 0 ? id : null;
    jsonData['login'] = login;
    jsonData['senha'] = senha;

    return jsonData;
  }

  String objectEncodeJson() {
    final jsonData = toJson;
    return json.encode(jsonData);
  }

  static UsuarioModel fromPlutoRow(PlutoRow row) {
    return UsuarioModel(
      id: row.cells['id']?.value,
      login: row.cells['login']?.value,
      senha: row.cells['senha']?.value,
    );
  }

  PlutoRow toPlutoRow() {
    return PlutoRow(
      cells: {
        'tempId': PlutoCell(value: tempId),
        'id': PlutoCell(value: id ?? 0),
        'login': PlutoCell(value: login ?? ''),
        'senha': PlutoCell(value: senha ?? ''),
      },
    );
  }

  UsuarioModel clone() {
    return UsuarioModel(
      id: id,
      login: login,
      senha: senha,
    );
  }


}