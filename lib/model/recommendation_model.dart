class RecommendationData {
  late double N;
  late double P;
  late double K;
  late double temp;
  late double humidity;
  late double ph;
  late double rainfall;

  RecommendationData({
    required this.N,
    required this.P,
    required this.K,
    required this.temp,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });
  Map<String, dynamic> toMap() {
    return {
      'N': N,
      'P': P,
      'K': K,
      'temp': temp,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall
    };
  }
}
