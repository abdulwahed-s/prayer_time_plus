// Generates `lib/src/data/auto_method_resolution.dart` from the bundled
// `tool/data/auto_method_resolution.json`.
//
// Run from the package root: `dart run tool/generate_data.dart`.
// Commit both this generator and the generated Dart file.

import 'dart:convert';
import 'dart:io';

void main() {
  final source = File('tool/data/auto_method_resolution.json');
  if (!source.existsSync()) {
    stderr.writeln('Cannot find ${source.path}; run from the package root.');
    exitCode = 1;
    return;
  }

  final data = jsonDecode(source.readAsStringSync()) as Map<String, dynamic>;
  final defaultMethod = data['mwl_default'] as String;
  final continent = _stringMap(data['continent'] as Map<String, dynamic>);
  final country = _stringMap(data['country'] as Map<String, dynamic>);

  final buffer =
      StringBuffer()
        ..writeln('// GENERATED FILE — do not edit by hand.')
        ..writeln('// Regenerate with: dart run tool/generate_data.dart')
        ..writeln()
        ..writeln(
          '/// Fallback method key when no country or continent matches.',
        )
        ..writeln("const String autoMethodDefault = '$defaultMethod';")
        ..writeln()
        ..writeln('/// Continent code (ISO-3166 continent) to method key.')
        ..writeln('const Map<String, String> autoContinentMethods = {')
        ..write(_entries(continent))
        ..writeln('};')
        ..writeln()
        ..writeln('/// Country code (ISO-3166 alpha-2) to method key.')
        ..writeln('const Map<String, String> autoCountryMethods = {')
        ..write(_entries(country))
        ..writeln('};');

  final output =
      File('lib/src/data/auto_method_resolution.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync(buffer.toString());
  stdout.writeln(
    'Wrote ${output.path} '
    '(${country.length} countries, ${continent.length} continents).',
  );
}

Map<String, String> _stringMap(Map<String, dynamic> raw) => {
  for (final entry in raw.entries) entry.key: entry.value as String,
};

String _entries(Map<String, String> map) {
  final keys = map.keys.toList()..sort();
  final buffer = StringBuffer();
  for (final key in keys) {
    buffer.writeln("  '$key': '${map[key]}',");
  }
  return buffer.toString();
}
