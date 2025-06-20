// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchResultModelAdapter extends TypeAdapter<SearchResultModel> {
  @override
  final int typeId = 1;

  @override
  SearchResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchResultModel(
      symbol: fields[1] as String?,
      name: fields[2] as String?,
      exchange: fields[3] as String?,
      micCode: fields[4] as String?,
      currency: fields[5] as String?,
      datetime: fields[6] as DateTime?,
      timestamp: fields[7] as int?,
      lastQuoteAt: fields[8] as int?,
      open: fields[9] as String?,
      high: fields[10] as String?,
      low: fields[11] as String?,
      close: fields[12] as String?,
      volume: fields[13] as String?,
      previousClose: fields[14] as String?,
      change: fields[15] as String?,
      percentChange: fields[16] as String?,
      averageVolume: fields[17] as String?,
      isMarketOpen: fields[18] as bool?,
      fiftyTwoWeek: fields[19] as FiftyTwoWeek?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchResultModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.exchange)
      ..writeByte(4)
      ..write(obj.micCode)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.datetime)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.lastQuoteAt)
      ..writeByte(9)
      ..write(obj.open)
      ..writeByte(10)
      ..write(obj.high)
      ..writeByte(11)
      ..write(obj.low)
      ..writeByte(12)
      ..write(obj.close)
      ..writeByte(13)
      ..write(obj.volume)
      ..writeByte(14)
      ..write(obj.previousClose)
      ..writeByte(15)
      ..write(obj.change)
      ..writeByte(16)
      ..write(obj.percentChange)
      ..writeByte(17)
      ..write(obj.averageVolume)
      ..writeByte(18)
      ..write(obj.isMarketOpen)
      ..writeByte(19)
      ..write(obj.fiftyTwoWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FiftyTwoWeekAdapter extends TypeAdapter<FiftyTwoWeek> {
  @override
  final int typeId = 2;

  @override
  FiftyTwoWeek read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FiftyTwoWeek(
      low: fields[1] as String?,
      high: fields[2] as String?,
      lowChange: fields[3] as String?,
      highChange: fields[4] as String?,
      lowChangePercent: fields[5] as String?,
      highChangePercent: fields[6] as String?,
      range: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FiftyTwoWeek obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.low)
      ..writeByte(2)
      ..write(obj.high)
      ..writeByte(3)
      ..write(obj.lowChange)
      ..writeByte(4)
      ..write(obj.highChange)
      ..writeByte(5)
      ..write(obj.lowChangePercent)
      ..writeByte(6)
      ..write(obj.highChangePercent)
      ..writeByte(7)
      ..write(obj.range);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FiftyTwoWeekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
