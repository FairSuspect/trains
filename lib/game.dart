import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final int n;
  final bool computer;
  const GameScreen({Key key, this.computer = false, this.n = 2})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int n;
  int counter = 0;
  int max;
  List whiteTrains = List.empty();
  List blackTraines = List.empty();
  List<Train> trains = List.empty();
  List<Train> startTrains = [];
  List<Train> depotTrains = [];
  List<Train> endTrains = [];
  @override
  void initState() {
    super.initState();
    n = widget.n;
    max = 3 * n - 1;
    whiteTrains = List.filled(n, Train(color: Colors.lightGreen));
    blackTraines = List.filled(n, Train(color: Colors.black));
    trains = [...blackTraines, ...whiteTrains];
    trains.shuffle();
    startTrains = trains;
    if (widget.computer) _ai();
  }

  double width = 175;
  // List<Train> get startTrains =>
  //     trains.where((train) => train.location == Locations.Start).toList();

  // List<Train> get endTrains =>
  //     trains.where((train) => train.location == Locations.End).toList();

  // List<Train> get depotTrains =>
  //     trains.where((train) => train.location == Locations.Depot).toList();
  Widget get _map => Container(
        width: width * 2 + 30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Количество ходов: $counter/$max"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  child: Stack(
                    children: [
                      Container(
                          height: _height, width: width, color: Colors.grey),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: endTrains
                              .map((e) => _horTrain(e.color))
                              .toList()
                              .sublist(0, endTrains.length >= 10 ? 10 : null))
                    ],
                  ),
                ),
                Container(
                  height: width,
                  child: Stack(
                    children: [
                      Container(
                          height: width, width: _height, color: Colors.grey),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.up,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: depotTrains
                              .map((e) => _verTrain(e.color))
                              .toList()
                              .sublist(0, depotTrains.length >= 10 ? 10 : null))
                    ],
                  ),
                ),
                Container(
                  width: width,
                  child: Stack(
                    children: [
                      Container(
                          height: _height, width: width, color: Colors.grey),
                      Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: startTrains
                              .map((e) => _horTrain(e.color))
                              .toList()
                              .sublist(0, startTrains.length >= 10 ? 10 : null))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Поезда"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Center(child: _map),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: widget.computer ? null : _out,
                      icon: Icon(Icons.rotate_left_sharp),
                      label: Text("Из")),
                  ElevatedButton.icon(
                      onPressed: widget.computer ? null : _through,
                      icon: Icon(Icons.arrow_left_sharp),
                      label: Text("Мимо")),
                  ElevatedButton.icon(
                      onPressed: widget.computer ? null : _in,
                      icon: Icon(Icons.arrow_circle_down_sharp),
                      label: Text("В"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool get isWin {
    bool check = true;
    Color lastColor = Colors.red;
    if (endTrains.length < 2 * n) return false;
    endTrains.forEach((train) {
      if (train.color == lastColor) {
        check = false;
      }
      lastColor = train.color;
    });
    return check;
  }

  void _ai() async {
    while (endTrains.length != 2 * n) {
      await Future.delayed(Duration(milliseconds: 1000));
      if (startTrains.length != 0 &&
          (endTrains.length == 0 ||
              startTrains?.last?.color != endTrains.last.color)) {
        _through();
      } else if (depotTrains.length != 0 &&
          depotTrains?.last?.color != endTrains.last.color) {
        _out();
      } else
        _in();
    }
  }

  void _out() {
    setState(() {
      endTrains.add(depotTrains.removeLast());
      counter++;
    });
    if (endTrains.length == 2 * n) {
      _winDialog();
    }
    if (counter > max) _winDialog();
  }

  void _through() {
    setState(() {
      endTrains.add(startTrains.removeLast());
      counter++;
    });
    if (endTrains.length == 2 * n) {
      _winDialog();
    }
    if (counter > max) _winDialog();
  }

  void _in() {
    setState(() {
      depotTrains.add(startTrains.removeLast());
      counter++;
    });
    if (counter > max) _winDialog();
  }

  void _winDialog() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(isWin ? 'Победа' : "Поражение"), actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil((route) => !Navigator.of(context).canPop());
                  },
                  child: Text("В меню")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => GameScreen(
                            n: widget.n, computer: widget.computer)));
                  },
                  child: Text("Заново"))
            ]));
  }

  static const double _height = 15;
  static const double _width = 20;
  Widget _verTrain(Color color) => Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: _height,
      height: _width,
      decoration: BoxDecoration(
          color: color, border: Border.all(color: Colors.blueGrey)));

  Widget _horTrain(Color color) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          color: color, border: Border.all(color: Colors.blueGrey)));
}

enum Locations { Start, Depot, End }

class Train {
  Color color;
  Train({this.color});
}
