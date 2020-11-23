import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:initium_2_comercio/Shop/bloc/bloc_shop.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;

  bool get isConnected => connection != null && connection.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    String idOrder = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Carga de Pedido"),
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            label: Text(
              "Recargar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            splashColor: Colors.blue[900],
            onPressed: () async {
              await getPairedDevices().then((_) {
                show('Lista de dispositivos recargada');
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: _isButtonUnavailable &&
                _bluetoothState == BluetoothState.STATE_ON,
            child: LinearProgressIndicator(
              backgroundColor: Colors.blue[900],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'HABILITAR BLUETOOTH',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Switch(
                  activeColor: Colors.blue[900],
                  activeTrackColor: Colors.blue[900],
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.black,
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool value) {
                    future() async {
                      if (value) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }
                      await getPairedDevices();
                      _isButtonUnavailable = false;
                      if (_connected) {
                        _disconnect();
                      }
                    }

                    future().then((_) {
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'CONECTESE A LA CENTRAL "INITIUM"',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DropdownButton(
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                          ),
                          dropdownColor: Colors.blueGrey[900],
                          iconDisabledColor: Colors.blue[800],
                          iconEnabledColor: Colors.blue[800],
                          iconSize: 30,
                          items: _getDeviceItems(),
                          onChanged: (value) => setState(() => _device = value),
                          value: _devicesList.isNotEmpty ? _device : null,
                        ),
                        RaisedButton(
                          color: Colors.blue[900],
                          onPressed: _isButtonUnavailable
                              ? null
                              : _connected ? _disconnect : _connect,
                          child: Text(
                            _connected ? 'Desconectar' : 'Conectar',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        _sendOnInfoOrderToBluetooth(idOrder, true);
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                colors: [Colors.blue[900], Colors.blue[400]],
                                begin: FractionalOffset(0.2, 0.0),
                                end: FractionalOffset(1.0, 0.6),
                                stops: [0.0, 0.6],
                                tileMode: TileMode.clamp)),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _connected ? 'CARGAR EN CAJON 1' : '',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Montserrat",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              _connected
                                  ? Icon(
                                      Icons.assignment_turned_in,
                                      color: Colors.white,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        _sendOnInfoOrderToBluetooth(idOrder, false);
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                colors: [Colors.blue[900], Colors.blue[400]],
                                begin: FractionalOffset(0.2, 0.0),
                                end: FractionalOffset(1.0, 0.6),
                                stops: [0.0, 0.6],
                                tileMode: TileMode.clamp)),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _connected ? 'CARGAR EN CAJON 2' : '',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Montserrat",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              _connected
                                  ? Icon(
                                      Icons.assignment_turned_in,
                                      color: Colors.white,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "NOTA: Si no encuentra a la central para conectarse, por favor verique que esté vinculada con su teléfono",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          RaisedButton(
                            color: Colors.blue[900],
                            elevation: 2,
                            child: Text(
                              "Vinculación Bluetooth",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Montserrat",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              FlutterBluetoothSerial.instance.openSettings();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        if (device.name == "Initium") {}
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No selecciono ningún dispositivo');
      setState(() {
        _connected = false;
      });
      setState(() => _isButtonUnavailable = false);
    } else {
      try {
        BluetoothConnection _connection =
            await BluetoothConnection.toAddress(_device.address);
        connection = _connection;
        setState(() {
          _connected = true;
        });
        show('Conectado con éxito');

        connection.input.listen(null).onDone(() {
          if (isDisconnecting) {
            print('Desconectado de forma local');
          } else {
            print('Desconectado de forma remota');
          }
          if (this.mounted) {
            setState(() {});
          }
        });
      } catch (exception) {
        print('No se ha podido conectar por el siguiente error:');
        print(exception);
        show('No fue posible la conexión, reintente');
        setState(() {
          _connected = false;
        });
      }
      setState(() => _isButtonUnavailable = false);
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;

  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection.close();
    show('Desconectado');
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _sendOnInfoOrderToBluetooth(String id, bool c1) async {
    ShopBloc shopBloc = BlocProvider.of(context);
    String code = c1 ? ".R$id" : ":R$id";
    int sumaxor = 0;

    for (int i = 0; i < code.length; i++) {
      sumaxor = code.codeUnits[i] ^ sumaxor;
    }

    c1
        ? connection.output
            .add(utf8.encode("@.R${id}${String.fromCharCode(sumaxor)}!"))
        : connection.output
            .add(utf8.encode("@:R${id}${String.fromCharCode(sumaxor)}!"));

    await connection.output.allSent;
    show('Aguarde confirmación de la central');
    await shopBloc.readyOrder(id);
    setState(() {
      _deviceState = 1;
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 4),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        backgroundColor: Colors.blueGrey[900],
        content: new Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w800,
              fontFamily: "Montserrat",
              fontSize: 16),
        ),
        duration: duration,
      ),
    );
  }
}
