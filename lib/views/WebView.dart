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

        print('------------------33');
//        flutterWebviewPlugin.evalJavascript(widget.jsCode);

//        flutterWebviewPlugin.evalJavascript("javascript:(" + "window.originalPostMessage = window.postMessage,"
//            + "window.postMessage = function(data) {" + widget.jsCode + ".postMessage(String(data));" + "}"
//            + ")");

//        flutterWebviewPlugin.reloadUrl("javascript:(" + "window.originalPostMessage = window.postMessage,"
//            + "window.postMessage = function(data) {" + widget.jsCode + ".postMessage(String(data));" + "}"
//            + ")");

      }

      print(wvs.type);
      if (wvs.type == WebViewState.startLoad) {

      }

      if (wvs.type == WebViewState.shouldStart) {
//        flutterWebviewPlugin.reloadUrl(url)

      }

      if(wvs.type == WebViewState.finishLoad){
        



      }
    });

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print('----------->12' + url);

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new WebviewScaffold(
      url: widget.url,
      appBar: new AppBar(
        centerTitle: true,
        title: Text(widget.title==null?widget.url:widget.title),
      ),
      withZoom: true,
      headers: {"x-token": widget.token},
      withLocalStorage: true,
      cookieList:widget.cookie ,
    );

//    return new Container();
  }
}
