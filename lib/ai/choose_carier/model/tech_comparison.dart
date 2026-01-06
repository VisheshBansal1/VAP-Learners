class TechComparison {
  final String name;
  final List<String> pros;
  final List<String> cons;
  final List<String> similarTech;
  final List<String> canBuild;

  final String marketReality;
  final String competitionLevel;
  final String futureDemand;
  final String isGoodChoice;
  final String bestFor;

  TechComparison({
    required this.name,
    required this.pros,
    required this.cons,
    required this.similarTech,
    required this.canBuild,
    required this.marketReality,
    required this.competitionLevel,
    required this.futureDemand,
    required this.isGoodChoice,
    required this.bestFor,
  });

  factory TechComparison.fromJson(Map<String, dynamic> json) {
    return TechComparison(
      name: json['name'] ?? '',
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      similarTech: List<String>.from(json['similarTech'] ?? []),
      canBuild: List<String>.from(json['canBuild'] ?? []),
      marketReality: json['marketReality'] ?? '',
      competitionLevel: json['competitionLevel'] ?? '',
      futureDemand: json['futureDemand'] ?? '',
      isGoodChoice: json['isGoodChoice'] ?? '',
      bestFor: json['bestFor'] ?? '',
    );
  }
}
