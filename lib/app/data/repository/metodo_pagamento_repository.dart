import 'package:financeiro_pessoal/app/infra/constants.dart';
import 'package:financeiro_pessoal/app/data/provider/api/metodo_pagamento_api_provider.dart';
import 'package:financeiro_pessoal/app/data/provider/drift/metodo_pagamento_drift_provider.dart';
import 'package:financeiro_pessoal/app/data/model/model_imports.dart';

class MetodoPagamentoRepository {
  final MetodoPagamentoApiProvider metodoPagamentoApiProvider;
  final MetodoPagamentoDriftProvider metodoPagamentoDriftProvider;

  MetodoPagamentoRepository({required this.metodoPagamentoApiProvider, required this.metodoPagamentoDriftProvider});

  Future getList({Filter? filter}) async {
    if (Constants.usingLocalDatabase) {
      return await metodoPagamentoDriftProvider.getList(filter: filter);
    } else {
      return await metodoPagamentoApiProvider.getList(filter: filter);
    }
  }

  Future<MetodoPagamentoModel?>? save({required MetodoPagamentoModel metodoPagamentoModel}) async {
    if (metodoPagamentoModel.id != null) {
      if (Constants.usingLocalDatabase) {
        return await metodoPagamentoDriftProvider.update(metodoPagamentoModel);
      } else {
        return await metodoPagamentoApiProvider.update(metodoPagamentoModel);
      }
    } else {
      if (Constants.usingLocalDatabase) {
        return await metodoPagamentoDriftProvider.insert(metodoPagamentoModel);
      } else {
        return await metodoPagamentoApiProvider.insert(metodoPagamentoModel);
      }
    }   
  }

  Future<bool> delete({required int id}) async {
    if (Constants.usingLocalDatabase) {
      return await metodoPagamentoDriftProvider.delete(id) ?? false;
    } else {
      return await metodoPagamentoApiProvider.delete(id) ?? false;
    }
  }
}