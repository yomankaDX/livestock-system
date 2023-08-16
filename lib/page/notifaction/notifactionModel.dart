class SensorData {
  
  final double magnitude;
  final double humidity;
  final double heartbeat;
  final double temperature;

  SensorData({
    
    required this.magnitude,
    required this.humidity,
    required this.heartbeat,
    required this.temperature,
  });

  factory SensorData.fromMap( Map<String, dynamic> map) {
    return SensorData(
      magnitude: map['Magnitude'] ?? 0.0,
      humidity: map['Humidity'] ?? 0.0,
      heartbeat: map['Heartbeat'] ?? 0.0,
      temperature: map['Temperature'] ?? 0.0,
    );
  }
}
