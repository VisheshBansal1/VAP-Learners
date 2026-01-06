import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/roadmap_node.dart';

class AIService {

  static final String _apiKey =
      dotenv.env['ROADMAP_GENERATOR_API']!;
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  // ===============================
  // JSON SAFETY (MANDATORY)
  // ===============================
  static Map<String, dynamic> _extractFirstJsonObject(String text) {
    int depth = 0;
    int start = -1;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == '{') {
        if (depth == 0) start = i;
        depth++;
      } else if (text[i] == '}') {
        depth--;
        if (depth == 0 && start != -1) {
          final jsonString = text.substring(start, i + 1);
          return jsonDecode(jsonString);
        }
      }
    }
    throw const FormatException('No valid JSON object found');
  }

  static List<dynamic> _extractFirstJsonArray(String text) {
    int depth = 0;
    int start = -1;

    for (int i = 0; i < text.length; i++) {
      if (text[i] == '[') {
        if (depth == 0) start = i;
        depth++;
      } else if (text[i] == ']') {
        depth--;
        if (depth == 0 && start != -1) {
          final jsonString = text.substring(start, i + 1);
          return jsonDecode(jsonString);
        }
      }
    }
    throw const FormatException('No valid JSON array found');
  }

  // ===============================
  // INITIAL ROADMAP (MASTER PROMPT)
  // ===============================
  static Future<RoadmapNode> generateRoadmap(String topic) async {
    final prompt =
        '''
You are an expert curriculum designer and industry practitioner. Return ONLY valid JSON. No explanation. No markdown. No extra text. Create a COMPLETE, INDUSTRY-READY learning roadmap. Topic: $topic GOAL: Take a learner from ZERO to INDUSTRY-READY. RULES: - Cover ALL major subdomains used in real-world projects - Include fundamentals, practical skills, and production concepts - Use industry-standard terminology - Organize logically from basics to advanced STRUCTURE: - 6 to 10 high-level sections - Each section must include: - id - label - children (empty array) JSON SCHEMA: { "id": "string", "label": "string", "children": [] } Return ONLY the JSON object.
''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.0,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];

    final jsonMap = _extractFirstJsonObject(content);
    return RoadmapNode.fromJson(jsonMap);
  }

  // ===============================
  // CONTEXT-AWARE NODE EXPANSION
  // ===============================
  static Future<List<RoadmapNode>> expandNode({
    required String rootTopic,
    required String nodePath,
  }) async {
    final prompt =
        '''
You are generating a SKILL-BASED LEARNING ROADMAP.

Return ONLY valid JSON.
No explanation.
No markdown.
No extra text.

ROOT DOMAIN:
$rootTopic

CURRENT NODE (EXPAND THIS ONLY):
$nodePath

OBJECTIVE:
Generate the NEXT LEVEL of LEARNABLE TOPICS a student should study.

STRICT DEFINITIONS:
- A subtopic = a concrete skill, concept, or hands-on area
- A subtopic must be something a learner can COMPLETE and move on from

ABSOLUTE RULES (DO NOT VIOLATE):
- DO NOT generate history, evolution, impact, comparison, vision, future, or lessons
- DO NOT restate or rephrase the parent topic
- DO NOT nest the same concept deeper using different words
- DO NOT explain, analyze, or narrate
- DO NOT generate documentation-style or blog-style headings

ROADMAP THINKING ONLY:
Ask yourself internally:
“What would a professional expect a beginner/intermediate learner to STUDY NEXT?”

EXPANSION LOGIC:
- If this is a FUNDAMENTAL topic → expand into core building blocks
- If this is a PRACTICAL topic → expand into tools, APIs, workflows
- If this is an ADVANCED topic → expand into optimization, architecture, best practices

OUTPUT RULES:
- Generate EXACTLY 3 to 5 subtopics (no more, no less)
- Each subtopic must be UNIQUE and NON-OVERLAPPING
- Use concise, industry-standard terminology

GOOD EXAMPLES:
- Widgets → StatelessWidget, StatefulWidget, Widget Tree
- State Management → Provider, Riverpod, Bloc
- Networking → REST APIs, HTTP Methods, Error Handling

BAD EXAMPLES (NEVER OUTPUT):
- History of X
- Evolution of X
- Introduction to X
- X Overview
- Impact of X
- Future of X
- Lessons learned from X
- X explained

FORMAT (STRICT):
[
  {
    "id": "short_unique_id",
    "label": "Clear skill or concept name",
    "children": []
  }
]

FINAL CHECK (internal only):
Would these topics appear in a serious course syllabus or job preparation roadmap?

Return ONLY the JSON array.

  
''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.0,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq API error: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];

    final list = _extractFirstJsonArray(content);

    return list
        .map((e) => RoadmapNode.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
