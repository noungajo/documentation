import 'package:andal/constants.dart';
import 'package:andal/controllers/paniercontroller.dart';
import 'package:andal/services/apiclient.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class StripePayment extends StatefulWidget {
  @override
  State<StripePayment> createState() => _StripePaymentState();
}

PanierController panierController = Get.find<PanierController>();
String paymentUrl =
    Client.url + "/fr/order/" + panierController.panier["tokenValue"] + "/pay";

class _StripePaymentState extends State<StripePayment> {
  // ignore: prefer_collection_literals
  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  // On destroy stream
  late StreamSubscription _onDestroy;
  // On urlChanged stream
  late StreamSubscription<String> _onUrlChanged;
  // On urlChanged stream
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  late StreamSubscription<WebViewHttpError> _onHttpError;
  late StreamSubscription<double> _onProgressChanged;
  late StreamSubscription<double> _onScrollYChanged;
  late StreamSubscription<double> _onScrollXChanged;
  final _urlCtrl = TextEditingController(text: paymentUrl);
  final _codeCtrl = TextEditingController(text: 'window.navigator.userAgent');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _history = [];
  @override
  void initState() {
    flutterWebViewPlugin.close();
    _urlCtrl.addListener(() {
      paymentUrl = _urlCtrl.text;
    });
    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Webview Destroyed')));
      }
    });
    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        /*
http://93.28.23.252:8080/fr/order/thank-you
lorsque cet url est appeleée décharger le webview et allerau pdf
        */

        setState(() {
          print(url);
          print("*******************");
          print(Client.url + "/fr/order/thank-you");
          if (url == Client.url + "/fr/order/thank-you") {
            Get.offNamed("/pdfviewer");
          } else {
            _history.add('onUrlChanged: $url');
          }
        });
      }
    });
    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });
    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });
    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });
    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: WebviewScaffold(
        url: paymentUrl,
        javascriptChannels: jsChannels,
        mediaPlaybackRequiresUserGesture: false,
        /* appBar: AppBar(
          title: const Text('Andaal payment'),
        ),*/
        withZoom: true,
        withLocalStorage: true,
        hidden: false,
        initialChild: Container(
          color: Colors.redAccent,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
        /*  bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  flutterWebViewPlugin.goBack();
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  flutterWebViewPlugin.goForward();
                },
              ),
              IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: () {
                  flutterWebViewPlugin.reload();
                },
              ),
            ],
          ),
        ),*/
      ),
    );

    /*   Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Andaal payment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pushNamed('/stripe_payment');
                    Get.toNamed('/stripe_payment');
                  },
                  child: const Text(" Payer !"),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}

