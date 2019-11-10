import 'dart:async';

main() {

  Stream<int> streamFromAsyncGenerator = createStreamUsingAsyncGenerator(const Duration(seconds: 1), 15);

  streamFromAsyncGenerator.listen((int value) {
    print('Value Form Async Generator: $value');
  });


  Stream<int> streamFromStreamController = createStreamUsingStreamController(const Duration(seconds: 1), 15);

  streamFromStreamController.listen((int value) {
    print('Value Form StreamController: $value');
  });
}

Stream<int> createStreamUsingAsyncGenerator(Duration interval, [int maxCount]) async* {
  print('createStreamUsingAsyncGenerator start');

  int counter = 0;
  while (true) {
    await Future.delayed(interval);
    counter++;
    yield counter;
    if (counter == maxCount) break;
  }

  print('createStreamUsingAsyncGenerator end');

}

Stream<int> createStreamUsingStreamController(Duration interval, [int maxCount]) {


  StreamController<int> controller;
  Timer timer;
  int counter = 0;

  void tick(_) {

    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (counter == maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }

  }

  void startTimer() {
    print('createStreamUsingStreamController start');

    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    print('createStreamUsingStreamController end');

  }

  controller = StreamController<int>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}

