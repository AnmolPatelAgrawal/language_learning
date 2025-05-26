import 'package:flutter/material.dart';
import 'session_data_manager.dart';

class ExportAllSessionsScreen extends StatefulWidget {
  const ExportAllSessionsScreen({super.key});

  @override
  State<ExportAllSessionsScreen> createState() =>
      _ExportAllSessionsScreenState();
}

class _ExportAllSessionsScreenState extends State<ExportAllSessionsScreen> {
  final SessionDataManager _dataManager = SessionDataManager();
  List<String> _sessionFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionFiles();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSessionFiles() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<String> files =
          await _dataManager.getAllSessionFiles();
      if (!mounted) return;
      setState(() {
        _sessionFiles = files;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading session files')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _exportAndDownloadSession(String fileName) async {
    final messenger = ScaffoldMessenger.of(context); 
    messenger.showSnackBar(
      SnackBar(content: Text('Exporting $fileName...')),
    );
    try {
      final String? csvContent = await _dataManager
          .exportAttemptsToCsv(fileName);
      if (csvContent != null) {
        final String csvFileName =
            fileName.replaceAll('.json', '.csv');
        await _dataManager.downloadCsv(
            csvContent, csvFileName);
        if (!mounted) return;
        messenger.showSnackBar( 
          SnackBar(
              content: Text('Data from $fileName downloaded as $csvFileName')),
        );
      } else {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to generate CSV content.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar( 
        SnackBar(content: Text('Error exporting $fileName: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export All Sessions'),
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessionFiles.isEmpty
              ? const Center(
                  child: Text('No saved sessions found.',
                      style: TextStyle(color: Colors.red, fontSize: 18)))
              : ListView.builder(
                  itemCount: _sessionFiles.length,
                  itemBuilder: (context, index) {
                    final fileName =
                        _sessionFiles[index];
                    String displayDate = "Unknown Date";
                    try {
                      final timestampPart = fileName
                          .replaceAll('.json', '')
                          .split('_')[0];
                      if (timestampPart.length >= 14) {
                        String year = timestampPart.substring(0, 4);
                        String month = timestampPart.substring(4, 6);
                        String day = timestampPart.substring(6, 8);
                        String hour = timestampPart.substring(9, 11);
                        String minute = timestampPart.substring(11, 13);
                        displayDate = "$year-$month-$day $hour:$minute";
                      }
                    } catch (e) {
                      // Keep "Unknown Date" if parsing fails
                    }

                    return ListTile(
                      title: Text('Session: $displayDate'),
                      subtitle: Text(fileName),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () =>
                            _exportAndDownloadSession(fileName),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete ALL local session files? This action cannot be undone.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete All'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;

                  if (confirmDelete) {
                    final messenger = ScaffoldMessenger.of(context); 
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('Deleting all local session files...')),
                    );
                    await _dataManager.deleteAllSessionFiles();
                    await _loadSessionFiles();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('All local session files deleted.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete All Local Sessions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
