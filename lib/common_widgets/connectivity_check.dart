import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ConnectivityStatus status) builder;

  const ConnectivityBuilder({required this.builder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          final status = snapshot.data == ConnectivityResult.none
              ? ConnectivityStatus.offline
              : ConnectivityStatus.online;
          return builder(context, status);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
