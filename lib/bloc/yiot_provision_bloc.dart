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

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:yiot_portal/provision/yiot-provision.dart';
import 'package:yiot_portal/components/yiot-countdown.dart';


part 'yiot_provision_event.dart';
part 'yiot_provision_state.dart';

// -----------------------------------------------------------------------------
class YiotProvisionBloc
    extends Bloc<YiotProvisionEvent, YiotProvisionState> {
//  static const _CHECK_PERIOD = 5000;
//  static const _OPERATION_DEADLINE = 120000;


  YiotProvisionBloc()
      : super(YiotProvisionStopped()) {

    on<YiotProvisionStoppedEvent>((event, emit) {
      emit(YiotProvisionStopped());
    });

    on<YiotProvisionWaitDeviceEvent>((event, emit) {
      emit(YiotProvisionWaitDevice());
    });

    on<YiotProvisionDeviceDetectedEvent>((event, emit) {
      emit(YiotProvisionDeviceDetected());
    });

    on<YiotProvisionInProgressEvent>((event, emit) {
      emit(YiotProvisionInProgress(p: event.p));
    });

    on<YiotProvisionDoneEvent>((event, emit) {
      emit(YiotProvisionDone());
    });

    on<YiotProvisionErrorEvent>((event, emit) {
      emit(YiotProvisionError());
    });
  }

  // ---------------------------------------------------------------------------
  //
  //   Start Device Provision
  //
  void startProvision() async {
    var p = await YIoTProvision.start();
    add(YiotProvisionInProgressEvent(p:p));
//    YIoTJenkinsService.start(
//            _yiotKeycloakService.token(), _yiotKeycloakService.currentUser(), model)
//        .then((value) {
//          if (value.err == null) {
//            _waitStart();
//            return;
//          }
//          add(YiotJenkinsErrorEvent(err: value.err!));
//    });
  }

  // ---------------------------------------------------------------------------
  //
  //   Stop Jenkins Service and it's communication
  //
//  void stop() {
//    _waitStop();
//    YIoTJenkinsService.stop(
//            _yiotKeycloakService.token(), _yiotKeycloakService.currentUser())
//        .then((value) {
//
//    });
//  }

  // ---------------------------------------------------------------------------
  //
  //  Force status request
  //
//  void update() {
//    YIoTJenkinsService.getState(
//        _yiotKeycloakService.token(), _yiotKeycloakService.currentUser())
//        .then((value) {
//      if (value.isEnabled) {
//        add(YiotJenkinsActiveEvent(jenkinsInfo: value));
//      } else {
//        add(YiotJenkinsInactiveEvent());
//      }
//    });
//  }

  // ---------------------------------------------------------------------------
  //
  //   Wait Service Start
  //
//  void _waitStart() {
//    // Emit event of waiting state
//    add(YiotJenkinsWaitActiveEvent());
//
//    // Run Count down timer for a operation processing
//    YIoTCountdown(
//      periodMs: _CHECK_PERIOD,
//      deadlineMs: _OPERATION_DEADLINE,
//
//      // Periodically need to check status
//      onPeriod: (timer, time) {
//        YIoTJenkinsService.getState(_yiotKeycloakService.token(),
//                _yiotKeycloakService.currentUser())
//            .then((value) {
//          if (value.isRunning) {
//            add(YiotJenkinsActiveEvent(jenkinsInfo: value));
//
//            // No need in new timer events
//            timer.cancel();
//          }
//        });
//      },
//
//      // In case of deadline need to set error state
//      onDeadline: () {
//        add(YiotJenkinsErrorEvent(err: YIoTErrorsRest.yiotErrRestTimeout()));
//      },
//    );
//  }

  // ---------------------------------------------------------------------------
  //
  //   Wait Service Stop
  //
//  void _waitStop() {
//    add(YiotJenkinsWaitInactiveEvent());
//
//    // Run Count down timer for a operation processing
//    YIoTCountdown(
//      periodMs: _CHECK_PERIOD,
//      deadlineMs: _OPERATION_DEADLINE,
//
//      // Periodically need to check status
//      onPeriod: (timer, time) {
//        YIoTJenkinsService.getState(_yiotKeycloakService.token(),
//                _yiotKeycloakService.currentUser())
//            .then((value) {
//          if (!value.isRunning) {
//            // Request inactive state
//            add(YiotJenkinsInactiveEvent());
//
//            // No need in new timer events
//            timer.cancel();
//          }
//        });
//      },
//
//      // In case of deadline need to set error state
//      onDeadline: () {
//        add(YiotJenkinsErrorEvent(err: YIoTErrorsRest.yiotErrRestTimeout()));
//      },
//    );
//  }

}

// -----------------------------------------------------------------------------
