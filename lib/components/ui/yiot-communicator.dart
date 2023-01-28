//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:yiot_portal/components/ui/yiot-primary-button.dart';
import 'package:yiot_portal/components/ui/yiot-secondary-button.dart';

// -----------------------------------------------------------------------------

typedef OnNeedSend = void Function(String data);
typedef OnReceived = void Function(String data);

class YIoTCommunicatorWidget extends StatefulWidget {
  final OnNeedSend? onNeedSend;
  final textStream;

  const YIoTCommunicatorWidget(
      {this.onNeedSend, required this.textStream, Key? key})
      : super(key: key);

  @override
  State<YIoTCommunicatorWidget> createState() => _YIoTCommunicatorWidgetState(
        onNeedSend: onNeedSend,
        textStream: textStream,
      );
}

class _YIoTCommunicatorWidgetState extends State<YIoTCommunicatorWidget> {
  static const _space = 10.0;
  final OnNeedSend? onNeedSend;
  final textStream;
  late TextEditingController _controller;
  var _stringData = "";

  _YIoTCommunicatorWidgetState({this.onNeedSend, required this.textStream});

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    try {
      textStream.listen((event) {
        _controller.text += "\n" + event;
      });
    } catch (_) {}
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_space),
      child: Column(
        children: [
          const SizedBox(height: _space),
          TextField(
            onChanged: (text) {
              _stringData = text;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Send data',
            ),
          ),
          const SizedBox(height: _space),
          Row(
            children: [
              YIoTPrimaryButton(
                text: 'Send',
                onPressed: () {
                  if (onNeedSend != null && _stringData.isNotEmpty) {
                    onNeedSend!(_stringData);
                  }
                },
              ),
              const SizedBox(width: _space),
              YIoTSecondaryButton(
                text: 'Clean logged data',
                onPressed: _controller.clear,
              ),
            ],
          ),
          const SizedBox(height: _space * 2),
          TextField(
            keyboardType: TextInputType.multiline,
            controller: _controller,
            readOnly: true,
            maxLines: 25,
            decoration: InputDecoration(
              hintText: "Communication data",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
