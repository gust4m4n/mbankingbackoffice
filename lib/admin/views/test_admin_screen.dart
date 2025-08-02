import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/admin/services/mbx_admin_api_service.dart';

class TestAdminScreen extends StatefulWidget {
  const TestAdminScreen({super.key});

  @override
  State<TestAdminScreen> createState() => _TestAdminScreenState();
}

class _TestAdminScreenState extends State<TestAdminScreen> {
  String debugInfo = '';

  Future<void> testGetAdmins() async {
    try {
      setState(() {
        debugInfo = 'Loading...';
      });

      final response = await MbxAdminApiService.getAdmins(page: 1, perPage: 10);

      setState(() {
        debugInfo =
            '''
Status Code: ${response.statusCode}
Status: ${response.status}
Message: ${response.message}

Data Type: ${response.jason.mapValue.runtimeType}
Data: ${response.jason.mapValue}
        ''';
      });
    } catch (e) {
      setState(() {
        debugInfo = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Admin API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: testGetAdmins,
              child: const Text('Test Get Admins'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Text(
                  debugInfo,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
