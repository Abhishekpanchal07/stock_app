// To parse this JSON data, do
//
//     final offlineDataModel = offlineDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'search_result_model.g.dart';

SearchResultModel offlineDataModelFromJson(String str) =>
    SearchResultModel.fromJson(json.decode(str));

String offlineDataModelToJson(SearchResultModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 1)
class SearchResultModel {
  @HiveField(1)
  final String? symbol;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? exchange;
  @HiveField(4)
  final String? micCode;
  @HiveField(5)
  final String? currency;
  @HiveField(6)
  final DateTime? datetime;
  @HiveField(7)
  final int? timestamp;
  @HiveField(8)
  final int? lastQuoteAt;
  @HiveField(9)
  final String? open;
  @HiveField(10)
  final String? high;
  @HiveField(11)
  final String? low;
  @HiveField(12)
  final String? close;
  @HiveField(13)
  final String? volume;
  @HiveField(14)
  final String? previousClose;
  @HiveField(15)
  final String? change;
  @HiveField(16)
  final String? percentChange;
  @HiveField(17)
  final String? averageVolume;
  @HiveField(18)
  final bool? isMarketOpen;
  @HiveField(19)
  final FiftyTwoWeek? fiftyTwoWeek;

  SearchResultModel({
    this.symbol,
    this.name,
    this.exchange,
    this.micCode,
    this.currency,
    this.datetime,
    this.timestamp,
    this.lastQuoteAt,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.previousClose,
    this.change,
    this.percentChange,
    this.averageVolume,
    this.isMarketOpen,
    this.fiftyTwoWeek,
  });

  SearchResultModel copyWith({
    String? symbol,
    String? name,
    String? exchange,
    String? micCode,
    String? currency,
    DateTime? datetime,
    int? timestamp,
    int? lastQuoteAt,
    String? open,
    String? high,
    String? low,
    String? close,
    String? volume,
    String? previousClose,
    String? change,
    String? percentChange,
    String? averageVolume,
    bool? isMarketOpen,
    FiftyTwoWeek? fiftyTwoWeek,
  }) =>
      SearchResultModel(
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        exchange: exchange ?? this.exchange,
        micCode: micCode ?? this.micCode,
        currency: currency ?? this.currency,
        datetime: datetime ?? this.datetime,
        timestamp: timestamp ?? this.timestamp,
        lastQuoteAt: lastQuoteAt ?? this.lastQuoteAt,
        open: open ?? this.open,
        high: high ?? this.high,
        low: low ?? this.low,
        close: close ?? this.close,
        volume: volume ?? this.volume,
        previousClose: previousClose ?? this.previousClose,
        change: change ?? this.change,
        percentChange: percentChange ?? this.percentChange,
        averageVolume: averageVolume ?? this.averageVolume,
        isMarketOpen: isMarketOpen ?? this.isMarketOpen,
        fiftyTwoWeek: fiftyTwoWeek ?? this.fiftyTwoWeek,
      );

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        symbol: json["symbol"],
        name: json["name"],
        exchange: json["exchange"],
        micCode: json["mic_code"],
        currency: json["currency"],
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        timestamp: json["timestamp"],
        lastQuoteAt: json["last_quote_at"],
        open: json["open"],
        high: json["high"],
        low: json["low"],
        close: json["close"],
        volume: json["volume"],
        previousClose: json["previous_close"],
        change: json["change"],
        percentChange: json["percent_change"],
        averageVolume: json["average_volume"],
        isMarketOpen: json["is_market_open"],
        fiftyTwoWeek: json["fifty_two_week"] == null
            ? null
            : FiftyTwoWeek.fromJson(json["fifty_two_week"]),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "exchange": exchange,
        "mic_code": micCode,
        "currency": currency,
        "datetime":
            "${datetime!.year.toString().padLeft(4, '0')}-${datetime!.month.toString().padLeft(2, '0')}-${datetime!.day.toString().padLeft(2, '0')}",
        "timestamp": timestamp,
        "last_quote_at": lastQuoteAt,
        "open": open,
        "high": high,
        "low": low,
        "close": close,
        "volume": volume,
        "previous_close": previousClose,
        "change": change,
        "percent_change": percentChange,
        "average_volume": averageVolume,
        "is_market_open": isMarketOpen,
        "fifty_two_week": fiftyTwoWeek?.toJson(),
      };
}

@HiveType(typeId: 2)
class FiftyTwoWeek {
  @HiveField(1)
  final String? low;
  @HiveField(2)
  final String? high;
  @HiveField(3)
  final String? lowChange;
  @HiveField(4)
  final String? highChange;
  @HiveField(5)
  final String? lowChangePercent;
  @HiveField(6)
  final String? highChangePercent;
  @HiveField(7)
  final String? range;

  FiftyTwoWeek({
    this.low,
    this.high,
    this.lowChange,
    this.highChange,
    this.lowChangePercent,
    this.highChangePercent,
    this.range,
  });

  FiftyTwoWeek copyWith({
    String? low,
    String? high,
    String? lowChange,
    String? highChange,
    String? lowChangePercent,
    String? highChangePercent,
    String? range,
  }) =>
      FiftyTwoWeek(
        low: low ?? this.low,
        high: high ?? this.high,
        lowChange: lowChange ?? this.lowChange,
        highChange: highChange ?? this.highChange,
        lowChangePercent: lowChangePercent ?? this.lowChangePercent,
        highChangePercent: highChangePercent ?? this.highChangePercent,
        range: range ?? this.range,
      );

  factory FiftyTwoWeek.fromJson(Map<String, dynamic> json) => FiftyTwoWeek(
        low: json["low"],
        high: json["high"],
        lowChange: json["low_change"],
        highChange: json["high_change"],
        lowChangePercent: json["low_change_percent"],
        highChangePercent: json["high_change_percent"],
        range: json["range"],
      );

  Map<String, dynamic> toJson() => {
        "low": low,
        "high": high,
        "low_change": lowChange,
        "high_change": highChange,
        "low_change_percent": lowChangePercent,
        "high_change_percent": highChangePercent,
        "range": range,
      };
}
