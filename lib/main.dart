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

import 'package:yiot_portal/routes/routes.dart';

import 'package:yiot_portal/theme/theme.dart';
import 'package:yiot_portal/pages/container/container-page.dart';

import 'package:yiot_portal/pages/manufacturing-page.dart';
import 'package:yiot_portal/pages/devices-page.dart';

// -----------------------------------------------------------------------------
void main() {
  runApp(YIoTPortal());
}

// -----------------------------------------------------------------------------
class YIoTPortal extends StatefulWidget {
  @override
  _YIoTPortalState createState() => _YIoTPortalState();
}

// -----------------------------------------------------------------------------
class _YIoTPortalState extends State<YIoTPortal> {
  var _routes = new YIoTRoutes();

  @override
  void initState() {
    super.initState();

    // Default page (Account)
    _routes.registerDefault(ContainerPage(
      routeData: "/",
      body: ManufacturingPage(),
    ));

    // Devices page
    _routes.registerDefault(ContainerPage(
      routeData: "/devices",
      body: DevicesPage(),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateTitle: (BuildContext context) => "YIoT Factory",
        debugShowCheckedModeBanner: false,

        // --- Theme ---
        theme: YIoTTheme.current(),

        // --- Routes ---
        onGenerateRoute: _routes.generator,
    );
  }
}

// -----------------------------------------------------------------------------
