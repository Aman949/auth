import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAtuhenticatedWithBiometric =
              await _auth.canCheckBiometrics;
          if (canAtuhenticatedWithBiometric) {
            try {
              final bool didAuthenticate = await _auth.authenticate(
                  localizedReason: "Please authenticate to see bank balance",
                  options: AuthenticationOptions(
                    biometricOnly: false,
                  ));
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } catch (e) {
              print(e);
            }
          }
        } 
        else {
          setState(() {
            _isAuthenticated = false;
          });
        }
        
      },
      child: Icon(_isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Account Balance",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          if (_isAuthenticated)
            Text(
              "\$ 23,235",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          if (!_isAuthenticated)
            Text(
              "******",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }
}
