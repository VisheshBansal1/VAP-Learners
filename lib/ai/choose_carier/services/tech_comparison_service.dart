import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learnify/ai/choose_carier/model/tech_comparison.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TechComparisonService {
static final String _apiKey =
      dotenv.env['CARRIER_API']!;
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  static Future<List<TechComparison>> compareTechnologies({
    required String goal,
    required List<String> technologies,
  }) async {
    final prompt =
        '''
You are a senior software career counselor with real hiring experience.

Return ONLY valid JSON.
No explanation.
No markdown.
No extra text.

USER GOAL:
$goal

TECHNOLOGIES:
${technologies.join(', ')}

TASK:
Analyze EACH technology honestly from a real career perspective.

RULES:
- Be practical, not motivational
- No hype or marketing language
- Avoid repeating the same points across technologies
- If a technology has risks, clearly state them

OUTPUT REQUIREMENTS:
For EACH technology, return an object with EXACTLY these fields:

- name (string)

- pros (array of strings)
  Each item must follow this format:
  "Advantage – short reason"

- cons (array of strings)
  Each item must follow this format:
  "Drawback – short reason"

- similarTech (array of strings)

- canBuild (array of strings)
  Real products, systems, or use cases

- marketReality (string)
  One short paragraph about jobs and adoption

- competitionLevel (string)
  ONLY one of: "Low", "Medium", "High"

- futureDemand (string)
  ONLY one of: "High", "Medium", "Niche"

- isGoodChoice (string)
  ONLY one of: "Yes", "No", "Depends"

- bestFor (string)
  Who should choose this and why (1–2 lines)

IMPORTANT:
- Do NOT add extra fields
- Do NOT change field names
- Do NOT add explanations outside values

JSON ARRAY FORMAT:
[
  {
    "name": "",
    "pros": [],
    "cons": [],
    "similarTech": [],
    "canBuild": [],
    "marketReality": "",
    "competitionLevel": "",
    "futureDemand": "",
    "isGoodChoice": "",
    "bestFor": ""
  }
]

Return ONLY the JSON array.

''';

    final res = await http.post(
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
        "temperature": 0.2,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    final content = jsonDecode(res.body)['choices'][0]['message']['content'];

    final List list = jsonDecode(
      content.substring(content.indexOf('['), content.lastIndexOf(']') + 1),
    );

    return list.map((e) => TechComparison.fromJson(e)).toList();
  }
}
