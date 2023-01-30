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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiot_portal/model/yiot-device.dart';
import 'package:yiot_portal/manual/yiot-manual.dart';
import 'package:yiot_portal/components/ui/yiot-title.dart';
import 'package:yiot_portal/components/ui/yiot-primary-button.dart';
import 'package:yiot_portal/bloc/yiot_provision_bloc.dart';
import 'package:yiot_portal/components/ui/yiot-waiting-indicator.dart';
import 'package:yiot_portal/components/ui/yiot-communicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// -----------------------------------------------------------------------------
class ManufacturingPage extends StatefulWidget {
  ManufacturingPage({Key? key}) : super(key: key);

  @override
  _ManufacturingPageState createState() => _ManufacturingPageState();
}

// -----------------------------------------------------------------------------
class _ManufacturingPageState extends State<ManufacturingPage> {
  late final YiotProvisionBloc _bloc;
  bool _needInitialization = true;

  @override
  Widget build(BuildContext context) {
    if (_needInitialization) {
      _bloc = Provider.of<YiotProvisionBloc>(context);
//      _bloc.update();
      _needInitialization = false;
    }

    return Column(children: [
      // -----------------------------------------------------------------------
      //  Title
      //
      YIoTTitle(title: 'Manufacturing'),
      Divider(
        color: Colors.black,
      ),
      Container(
        alignment: Alignment.topCenter,
        child: BlocBuilder<YiotProvisionBloc, YiotProvisionState>(
          builder: (context, state) {
            //
            //  Provision is stopped
            //
            if (state is YiotProvisionStopped) {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    YIoTPrimaryButton(
                      text: 'Start provision',
                      onPressed: () {
                        _bloc.startProvision();
//                        YIoTManual.create(YIoTDevice(
//                          manufacturer: "YIoT",
//                          model: "CV-2SE",
//                          serial: "0123456789",
//                          macAddress: "01:02:03:04:05:06",
//                          publicKey: "AAAAC3NzaC1lZDI1NTE5AAAAIFW5JvT1cYyiuT7+Q6ghCoCGLi5xcEVdBKUcfxy835bC",
//                          icon: "assets/images/yiot.png",
//                          docLink: "https://cdn.yiot.dev/docs/devices/cv-2se.pdf",
//                          initialUser: "yiot",
//                          initialPassword: "J!H@KLedds76%#57",
//                          initialAddress: "192.168.1.1",
//                          explain: "DO NOT FORGET TO CHANGE YOUR INITIAL PASSWORDS",
//                        ));
                      },
                    ),
                  ],
                ),
              );
            }

            //
            //  Devices wait
            //
            if (state is YiotProvisionWaitDevice) {
              return YIoTWaitingIndicator(
                message: 'Devices detection ...',
              );
            }

            //
            //  Device is detected
            //
            if (state is YiotProvisionDeviceDetected) {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Device detected ...'),
                  ],
                ),
              );
            }

            //
            //  Provision is in progress
            //
            if (state is YiotProvisionInProgress) {
              return Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Provision is in progress ...'),
                    YIoTCommunicatorWidget(textStream: state.stream),
                  ],
                ),
              );
            }

            //
            //  Provision done
            //
            if (state is YiotProvisionDone) {
              return Text('Provision done');
            }

            //
            //  Provision error
            //
            if (state is YiotProvisionError) {
              return AlertDialog(
                title: const Text('Device provision error'),
                content: const Text('Would you like to make another attempt ?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => _bloc.cancel(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => _bloc.startProvision(),
                    child: const Text('Yes'),
                  ),
                ],
              );
            }

            return Text('UNKNOWN STATE');
          },
        ),
      ),
    ]);
  }
}

// -----------------------------------------------------------------------------
