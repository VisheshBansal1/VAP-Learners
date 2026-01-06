import 'package:flutter/material.dart';
import 'package:learnify/ai/choose_carier/model/tech_comparison.dart';
import '../services/tech_comparison_service.dart';

class TechComparisonScreen extends StatefulWidget {
  const TechComparisonScreen({super.key});

  @override
  State<TechComparisonScreen> createState() =>
      _TechComparisonScreenState();
}

class _TechComparisonScreenState extends State<TechComparisonScreen> {
  /// OPTIONAL GOAL
  final TextEditingController goalCtrl = TextEditingController();

  /// OPTIONAL DOMAIN SUGGESTIONS
  final List<String> careerGoals = [
    'App Developer',
    'Web Developer',
    'Backend Developer',
    'AI / ML Engineer',
    'Game Developer',
    'DevOps Engineer',
    'Data Analyst',
    'Cybersecurity Engineer',
    'Database Engineer',
  ];

  final Map<String, List<String>> goalTechMap = {
    'App Developer': ['Flutter', 'React Native', 'Kotlin', 'Swift', 'Java'],
    'Web Developer': ['React', 'Angular', 'Vue', 'Next.js'],
    'Backend Developer': ['Node.js', 'Java', 'Spring Boot', 'Django', 'Go'],
    'AI / ML Engineer': ['Python', 'TensorFlow', 'PyTorch'],
    'Game Developer': ['Unity', 'Unreal Engine', 'C#'],
    'DevOps Engineer': ['Docker', 'Kubernetes', 'AWS'],
    'Data Analyst': ['Python', 'SQL', 'Power BI'],
    'Cybersecurity Engineer': ['Networking', 'Linux', 'SIEM'],
    'Database Engineer': ['MySQL', 'PostgreSQL', 'MongoDB'],
  };

  String? selectedGoal;
  final Set<String> selectedTech = {};
  final TextEditingController customTechCtrl =
      TextEditingController();

  bool loading = false;
  List<TechComparison> results = [];

  /// MAIN ACTION
  Future<void> compare() async {
    final String goal = goalCtrl.text.trim().isNotEmpty
        ? goalCtrl.text.trim()
        : (selectedGoal ?? 'General Software Career');

    if (selectedTech.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one technology'),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
      results.clear();
    });

    try {
      final data =
          await TechComparisonService.compareTechnologies(
        goal: goal,
        technologies: selectedTech.toList(),
      );
      setState(() => results = data);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestedTech =
        selectedGoal != null ? goalTechMap[selectedGoal!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Technology Comparison'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GOAL INPUT (OPTIONAL)
            TextField(
              controller: goalCtrl,
              decoration: const InputDecoration(
                labelText: 'Career goal (optional)',
                hintText:
                    'e.g. Blockchain Developer, Cloud Security Engineer',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// DOMAIN SUGGESTION (OPTIONAL)
            DropdownButtonFormField<String>(
              value: selectedGoal,
              hint: const Text('Or choose a suggested field'),
              items: careerGoals
                  .map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Text(g),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => selectedGoal = v);
              },
              decoration:
                  const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            /// SUGGESTED TECH
            if (suggestedTech.isNotEmpty) ...[
              Text(
                'Suggested Technologies',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: suggestedTech.map((t) {
                  final selected = selectedTech.contains(t);
                  return FilterChip(
                    label: Text(t),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        v
                            ? selectedTech.add(t)
                            : selectedTech.remove(t);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            /// CUSTOM TECH INPUT
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customTechCtrl,
                    decoration: const InputDecoration(
                      hintText:
                          'Add any technology (Rust, SAP, Solidity)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final tech =
                        customTechCtrl.text.trim();
                    if (tech.isEmpty) return;
                    setState(() {
                      selectedTech.add(tech);
                      customTechCtrl.clear();
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// SELECTED TECH PREVIEW
            Wrap(
              spacing: 6,
              children: selectedTech.map((t) {
                return Chip(
                  label: Text(t),
                  onDeleted: () =>
                      setState(() => selectedTech.remove(t)),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// ACTION BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : compare,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Compare & Get Guidance'),
              ),
            ),

            const SizedBox(height: 16),

            /// RESULTS
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text('Results will appear here'),
                    )
                  : ListView(
                      children: results.map((t) {
                        return GestureDetector(
                          onTap: () => _openDetailSheet(t),
                          child: _buildResultCard(t),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// SUMMARY CARD
  Widget _buildResultCard(TechComparison t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Future Demand: ${t.futureDemand}'),
            Text('Competition: ${t.competitionLevel}'),
            const SizedBox(height: 6),
            Text(
              'Tap to view full analysis →',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FULL SCREEN DETAIL VIEW
  void _openDetailSheet(TechComparison t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollCtrl) {
            return SingleChildScrollView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              child: _buildDetailContent(t),
            );
          },
        );
      },
    );
  }

  /// DETAIL CONTENT
  Widget _buildDetailContent(TechComparison t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        _section('Pros (Why it helps)', t.pros),
        _section('Cons (Real drawbacks)', t.cons),
        _section('Similar Technologies', t.similarTech),
        _section('What You Can Build', t.canBuild),

        const SizedBox(height: 12),

        _info('Market Reality', t.marketReality),
        _info('Competition Level', t.competitionLevel),
        _info('Future Demand', t.futureDemand),
        _info('Is It a Good Choice?', t.isGoodChoice),
        _info('Best For', t.bestFor),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _section(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          ...items.map((e) => Text('• $e')),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    if (value.trim().isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RichText(
        text: TextSpan(
          style:
              const TextStyle(color: Colors.white, height: 1.4),
          children: [
            TextSpan(
              text: '$title: ',
              style:
                  const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
