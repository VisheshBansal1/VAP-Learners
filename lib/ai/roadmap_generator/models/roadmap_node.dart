class RoadmapNode {
  final String id;
  final String label;
  final String path; // NEW
  List<RoadmapNode> children;

  RoadmapNode({
    required this.id,
    required this.label,
    required this.path,
    required this.children,
  });

  factory RoadmapNode.fromJson(
    Map<String, dynamic> json, {
    String parentPath = '',
  }) {
    final label = (json['label'] ?? '').toString();
    final currentPath =
        parentPath.isEmpty ? label : '$parentPath > $label';

    return RoadmapNode(
      id: (json['id'] ?? '').toString(),
      label: label,
      path: currentPath,
      children: (json['children'] as List? ?? [])
          .map(
            (e) => RoadmapNode.fromJson(
              Map<String, dynamic>.from(e),
              parentPath: currentPath,
            ),
          )
          .toList(),
    );
  }
}
