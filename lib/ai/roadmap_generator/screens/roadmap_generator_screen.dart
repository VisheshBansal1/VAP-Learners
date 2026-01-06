import 'package:flutter/material.dart';
import '../models/roadmap_node.dart';
import '../services/ai_service.dart';

class RoadmapGeneratorScreen extends StatefulWidget {
  const RoadmapGeneratorScreen({super.key});

  @override
  State<RoadmapGeneratorScreen> createState() =>
      _RoadmapGeneratorScreenState();
}

class _RoadmapGeneratorScreenState extends State<RoadmapGeneratorScreen> {
  final TextEditingController _topicCtrl = TextEditingController();

  RoadmapNode? roadmap;
  String? rootTopic;
  bool loading = false;

  /// Nodes currently fetching from AI
  final Set<String> expandingNodes = {};

  /// Nodes currently expanded (visible)
  final Set<String> expandedNodes = {};

  static const int maxDepth = 3; // 🔒 HARD LIMIT

  // ===============================
  // GENERATE ROOT ROADMAP
  // ===============================
  Future<void> generateRoadmap() async {
    setState(() {
      loading = true;
      roadmap = null;
      rootTopic = null;
      expandingNodes.clear();
      expandedNodes.clear();
    });

    try {
      final result =
          await AIService.generateRoadmap(_topicCtrl.text.trim());

      setState(() {
        roadmap = result;
        rootTopic = result.label;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Roadmap Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// INPUT
            TextField(
              controller: _topicCtrl,
              decoration: const InputDecoration(
                labelText: 'Enter topic',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : generateRoadmap,
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Generate Roadmap'),
              ),
            ),

            const SizedBox(height: 16),

            /// RESULT
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : roadmap == null
                      ? const Center(child: Text('No roadmap generated'))
                      : SingleChildScrollView(child: _buildTree()),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // ROOT TREE
  // ===============================
  Widget _buildTree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ROOT HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            roadmap!.label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// LEVEL 1 SECTIONS
        ...roadmap!.children.map(
          (n) => Card(
            elevation: 0,
            color: Colors.grey.shade100,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: buildNode(n, depth: 1),
            ),
          ),
        ),
      ],
    );
  }

  // ===============================
  // SINGLE NODE
  // ===============================
  Widget buildNode(RoadmapNode node, {required int depth}) {
    final bool isLoading = expandingNodes.contains(node.id);
    final bool hasChildren = node.children.isNotEmpty;
    final bool isExpanded = expandedNodes.contains(node.id);
    final bool canExpand = depth < maxDepth;

    return Padding(
      padding: EdgeInsets.only(left: depth == 1 ? 0 : depth * 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              if (!canExpand) return;

              // Toggle if already loaded
              if (hasChildren) {
                setState(() {
                  isExpanded
                      ? expandedNodes.remove(node.id)
                      : expandedNodes.add(node.id);
                });
                return;
              }

              // Load from AI
              if (!isLoading) {
                _expandNode(node);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color:
                    depth == 1 ? Colors.white : Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ICON
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: isLoading
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2),
                          )
                        : hasChildren
                            ? Icon(
                                isExpanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                size: 20,
                              )
                            : canExpand
                                ? const Icon(Icons.add, size: 18)
                                : const Icon(Icons.circle, size: 8),
                  ),

                  const SizedBox(width: 8),

                  /// TEXT
                  Expanded(
                    child: Text(
                      node.label,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: depth == 1 ? 16 : 14,
                        fontWeight: depth == 1
                            ? FontWeight.w600
                            : FontWeight.w400,
                        height: 1.5,
                        color: canExpand
                            ? Colors.black
                            : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// CHILDREN
          if (hasChildren && isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                children: node.children
                    .map(
                      (c) => buildNode(c, depth: depth + 1),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ===============================
  // AI EXPANSION
  // ===============================
  Future<void> _expandNode(RoadmapNode node) async {
    if (rootTopic == null) return;

    setState(() => expandingNodes.add(node.id));

    try {
      final children = await AIService.expandNode(
        rootTopic: rootTopic!,
        nodePath: node.path,
      );

      setState(() {
        node.children.addAll(children);
        expandedNodes.add(node.id); // auto-expand
      });
    } finally {
      setState(() => expandingNodes.remove(node.id));
    }
  }
}
