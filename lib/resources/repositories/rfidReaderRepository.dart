import 'dart:async';

import 'package:biblio/models/tag.dart';
import 'package:biblio/resources/api/PlatformApi.dart';
import 'package:biblio/resources/repositories/tagsRepository.dart';
import 'package:flutter/services.dart';

class RfidReaderRepository {
  PlatformApi _platformApi;
  TagsRepository _tagsRepository;
  double _readerRssiAtOneMeter;
  Function onStatusChanged;
  Function onTagsRead;

  RfidReaderRepository({this.onStatusChanged, this.onTagsRead})
      : assert(onStatusChanged != null),
        assert(onTagsRead != null);

  init() {
    _platformApi = PlatformApi(methodChannelID: 'biblio/rfidReader');
    _platformApi.methodCallHandler = _methodChannelHandler;
    _tagsRepository = TagsRepository();
  }

  dispose() {
    _tagsRepository.dispose();
    // Dispose this
  }

  /// Handles the method calls made by the reader (native code).
  /// It includes callbacks for reader events.
  Future<void> _methodChannelHandler(MethodCall call) async {
    switch (call.method) {
      case "onStatusChanged":
        _processStatusChanged(call);
        break;

      case "onTagsRead":
        _processReadTags(call);
        break;

      default:
        throw MissingPluginException();
    }
  }

  Future<void> _processStatusChanged(MethodCall call) async {
    int status = call.arguments;
    onStatusChanged(status);

    // If the reader is opened them get reader's RSSI at one meter
    if (status == 1) {
      _readerRssiAtOneMeter = await getRssiAtOneMeter();
    }
  }

  /// Process the read tags reported by the reader
  Future<void> _processReadTags(MethodCall call) async {
    if (call.arguments.length > 0) {
      await _tagsRepository.addTagsFromJson(
          call.arguments, _readerRssiAtOneMeter);

      onTagsRead();
    }
  }

  Future<void> requestReaderStatus(Function onError) async {
    Function newOnError;
    if(onError!=null){
      newOnError=(String error){
        onError('No se pudo obtener el estado actual del lector.');
      };
    }
    _platformApi.invokeMethodWithCallbacks('reportCurrentStatus', null, newOnError);
  }

  Future<void> openReader(Function onError) async {
    Function newOnError;
    if(onError!=null){
      newOnError=(String error){
        onError('No se pudo abrir el lector.');
      };
    }
    _platformApi.invokeMethodWithCallbacks('open', null, newOnError);
  }

  Future<void> closeReader(Function onError) async {
    Function newOnError;
    if(onError!=null){
      newOnError=(String message){
        onError('No se pudo cerrar el lector.');
      };
    }
    _platformApi.invokeMethodWithCallbacks('close', null, newOnError);
  }

  Future<void> startInventory(Function onError) async {
    Function newOnError;
    if(onError!=null){
      newOnError=(String message){
        onError('No se pudo iniciar el inventario.');
      };
    }
    _platformApi.invokeMethodWithCallbacks('startInventory', null, newOnError);
  }

  Future<void> stopInventory(Function onError) async {
    Function newOnError;
    if(onError!=null){
      newOnError=(String message){
        onError('No se pudo detener el inventario.');
      };
    }
    _platformApi.invokeMethodWithCallbacks('stopInventory', null, newOnError);
  }

  Future<void> clear(Function onSuccess, Function onError) async {
    Function newOnSuccess, newOnError;
    if (onSuccess != null) {
      newOnSuccess = ([dynamic args]) {
        _tagsRepository.clear();
        onSuccess();
      };
    }
    
    if(onError!=null){
      newOnError=(String message){
        onError('No se pudo descartar todas las etiquetas leídas.');
      };
    }

    _platformApi.invokeMethodWithCallbacks('clear', newOnSuccess, newOnError);
  }

  Future<void> discardTag(
      String tagEpc, Function onSuccess, Function onError) async {
    
    Function newOnSuccess, newOnError;

    if (onSuccess != null) {
      newOnSuccess = ([dynamic args]) {
        _tagsRepository.removeTag(tagEpc);
        onSuccess();
      };
    }
    
    if(onError!=null){
      newOnError=(String message){
        onError('No se pudo decartar la etiqueta $tagEpc.');
      };
    }

    _platformApi.invokeMethodWithCallbacks('discardTag', newOnSuccess, newOnError, tagEpc);
  }

  Future<void> requestReadTags() async {
    _platformApi.invokeMethodWithCallbacks('sendTags', null, null);
  }

  Future<double> getRssiAtOneMeter() async {
    return await _platformApi.invokeMethodAnGetResult('getRssiAtOneMeter') as double;
  }

  List<Tag> getReadTags() {
    return _tagsRepository.getTagsAsCollection();
  }

}
