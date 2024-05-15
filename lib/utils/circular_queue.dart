import 'dart:collection';

class CircularQueue<T> {
  Queue<T> values = Queue<T>();
  Queue<DateTime> dateTimes = Queue();

  int size;
  Duration duration;

  CircularQueue(this.size, this.duration);

  void add(T value) {
    values.add(value);
    dateTimes.add(DateTime.now());
    if (values.length > size &&
        dateTimes.first.add(duration).isBefore(DateTime.now())) {
      values.removeFirst();
      dateTimes.removeFirst();
    }
  }

  List<T> toList() {
    return values.toList();
  }

  T last() {
    return values.last;
  }
}

// TODO: implement some form of time series data structure
// basically, keep everything for n seconds (eg. 60) in this circular queue
// then, every minute sample/average/median? and save to a minute queue
// sample that again every hour to an hour queue

int bufferSize = 120;
Duration duration = const Duration(seconds: 60);

class BufferedPowerMeter {
  bool ac = true;
  CircularQueue<double> currentL1 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> currentL2 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> currentL3 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> currentN = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> currentDC = CircularQueue<double>(bufferSize, duration);

  CircularQueue<double> powerL1 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> powerL2 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> powerL3 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> powerTotal =
      CircularQueue<double>(bufferSize, duration);

  CircularQueue<double> freqL1 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> freqL2 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> freqL3 = CircularQueue<double>(bufferSize, duration);

  CircularQueue<double> voltageL1 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> voltageL2 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> voltageL3 = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> voltageDC = CircularQueue<double>(bufferSize, duration);
}

BufferedPowerMeter bufferedPowerMeter = BufferedPowerMeter();

class BufferedTelemetry {
  CircularQueue<double> fanRPM = CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> rcdCurrent =
      CircularQueue<double>(bufferSize, duration);
  CircularQueue<bool> relaisOn = CircularQueue<bool>(bufferSize, duration);
  CircularQueue<double> supplyVoltage12V =
      CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> supplyMinusVoltage12V =
      CircularQueue<double>(bufferSize, duration);
  CircularQueue<double> temperature =
      CircularQueue<double>(bufferSize, duration);

  bool isEmpty() {
    if (fanRPM.values.isEmpty ||
        rcdCurrent.values.isEmpty ||
        relaisOn.values.isEmpty ||
        supplyVoltage12V.values.isEmpty ||
        supplyMinusVoltage12V.values.isEmpty ||
        temperature.values.isEmpty) {
      return true;
    }
    return false;
  }
}

BufferedTelemetry bufferedTelemetry = BufferedTelemetry();
