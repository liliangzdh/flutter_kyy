import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String url;
  final String jsCode;
  final String token;
  final List<Map<String,String>> cookie;
  final String title;

  WebView({Key key, this.url, this.jsCode,  this.token,this.cookie,this.title}) : super(key: key);

  @override
  _WebView createState() {
    // TODO: implement createState
    return new _WebView();
  }
}

class _WebView extends State<WebView> {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      if (widget.jsCode != null && widget.jsCode.length != 0) {
      }

      if (wvs.type == WebViewState.startLoad) {

      }

      if (wvs.type == WebViewState.shouldStart) {

      }

      if(wvs.type == WebViewState.finishLoad){

      }
    });

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
    });

  }

  @override
  Widget build(BuildContext context) {


    return new WebviewScaffold(
      url: widget.url,
      appBar: new AppBar(
        centerTitle: true,
        title: Text(widget.title==null?widget.url:widget.title),
      ),
      withZoom: true,
      withJavascript: true,
      headers: {"x-token": widget.token},
      withLocalStorage: true,
      cookieList:widget.cookie ,
    );
  }
}
