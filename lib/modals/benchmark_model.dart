class BenchmarkModel {
  Meta? meta;
  List<Values>? values;
  String? status;

  BenchmarkModel({this.meta, this.values, this.status});

  BenchmarkModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (values != null) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Meta {
  String? symbol;
  String? interval;
  String? currency;
  String? exchangeTimezone;
  String? exchange;
  String? micCode;
  String? type;

  Meta(
      {this.symbol,
      this.interval,
      this.currency,
      this.exchangeTimezone,
      this.exchange,
      this.micCode,
      this.type});

  Meta.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    interval = json['interval'];
    currency = json['currency'];
    exchangeTimezone = json['exchange_timezone'];
    exchange = json['exchange'];
    micCode = json['mic_code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['interval'] = interval;
    data['currency'] = currency;
    data['exchange_timezone'] = exchangeTimezone;
    data['exchange'] = exchange;
    data['mic_code'] = micCode;
    data['type'] = type;
    return data;
  }
}

class Values {
  String? datetime;
  String? open;
  String? high;
  String? low;
  String? close;
  String? volume;

  Values(
      {this.datetime, this.open, this.high, this.low, this.close, this.volume});

  Values.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datetime'] = datetime;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['volume'] = volume;
    return data;
  }
}
