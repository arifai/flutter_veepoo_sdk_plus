import 'package:equatable/equatable.dart';
import 'package:flutter_veepoo_sdk/statuses/heart_statuses.dart';

/// {@template heart_rate}
/// A class that represents the result of a heart rate detection.
/// {@endtemplate}
class HeartRate extends Equatable {
  /// {@macro heart_rate}
  const HeartRate(this.data, this.state);

  /// The heart rate data.
  final int data;

  /// The state of the heart.
  final HeartStatuses? state;

  /// Converts a [Map<String, dynamic>] to a [HeartRate].
  factory HeartRate.fromJson(Map<String, dynamic> map) {
    return HeartRate(map['data'], HeartStatuses.fromString(map['state']));
  }

  @override
  List<Object?> get props => [data, state];
}
