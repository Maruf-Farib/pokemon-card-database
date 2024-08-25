import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Function to fetch the latest release information from GitHub
Future<Map<String, dynamic>> fetchLatestRelease() async {
  final response = await http.get(
    Uri.parse(
        'https://api.github.com/repos/Maruf-Farib/pokemon-card-database/releases/latest'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch latest release');
  }
}

// Function to check for updates by comparing the current version with the latest version
Future<void> checkForUpdates(BuildContext context) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final String currentVersion = packageInfo.version;

  try {
    final release = await fetchLatestRelease();
    final String latestVersion = release['tag_name'];
    final String apkUrl = release['assets'][0]['browser_download_url'];

    if (latestVersion != currentVersion) {
      _showUpdateSnackbar(context, apkUrl);
    }
  } catch (e) {
    //print('Failed to check for updates: $e');
  }
}

// Function to show a Snackbar with a button to update the app
void _showUpdateSnackbar(BuildContext context, String apkUrl) {
  final snackBar = SnackBar(
    content: const Text('A new version is available!'),
    action: SnackBarAction(
      label: 'Update',
      onPressed: () {
        _launchURL(apkUrl);
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Function to launch the URL in an external browser
Future<void> _launchURL(String url) async {
  await launchUrlString(url);
}
