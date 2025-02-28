import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _file;
  bool _isUploading = false;
  String? _uploadMessage;
  String? _fileSize;
  double? _uploadCost;
  String? _selectedCloud;
  late double _walletBalance = 10; // Initial wallet balance, adjust as needed
  final Map<String, double> _cloudPrices = {
    'Cloud Server 1': 100.0,
    'Cloud Server 2': 200.0,
    'Cloud Server 3': 300.0,
  };
  int _days = 1; // Default to 1 day
  final TextEditingController _daysController = TextEditingController(text: '1');

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null) {
        setState(() {
          _file = File(result.files.single.path!);
          _fileSize = _getFileSize(_file!.lengthSync());
          _uploadCost = _selectedCloud != null ? _calculateUploadCost(_file!.lengthSync(), _selectedCloud!, _days) : null;
        });
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  String _getFileSize(int bytes) {
    const int KB = 1024;
    const int MB = 1024 * KB;
    const int GB = 1024 * MB;

    if (bytes >= GB) {
      return '${(bytes / GB).toStringAsFixed(2)} GB';
    } else if (bytes >= MB) {
      return '${(bytes / MB).toStringAsFixed(2)} MB';
    } else if (bytes >= KB) {
      return '${(bytes / KB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }

  double _calculateUploadCost(int bytes, String cloud, int days) {
    const int GB = 1024 * 1024 * 1024;
    return ((bytes / GB) * _cloudPrices[cloud]!) * days;
  }

  Future<void> _uploadFile() async {
    if (_file == null) {
      setState(() {
        _uploadMessage = 'No file selected';
      });
      return;
    }
    if (_selectedCloud == null) {
      setState(() {
        _uploadMessage = 'No cloud storage selected';
      });
      return;
    }

    if (_walletBalance < _uploadCost!) {
      setState(() {
        _uploadMessage = 'Insufficient balance. Please add funds to your wallet.';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadMessage = null;
    });

    try {
      final storage = FirebaseStorage.instance;
      final fileName = _file!.path.split('/').last;
      final ref = storage.ref().child('$_selectedCloud/$fileName');
      await ref.putFile(_file!);
      final downloadURL = await ref.getDownloadURL();

      // Deduct upload cost from wallet balance
      setState(() {
        _walletBalance -= _uploadCost!;
      });

      //Store the file details in Firestore
      await FirebaseFirestore.instance.collection('Uploads').add({
        'fileName': fileName,
        'filePath': _file!.path,
        "Server": _selectedCloud,
        'downloadURL': downloadURL,
        'startDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'endDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: _days))),
        'uploadCost': _uploadCost,
      });

      setState(() {
        _isUploading = false;
        _uploadMessage = 'File uploaded successfully to $_selectedCloud. Download URL: $downloadURL';
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadMessage = 'Error uploading file: $e';
      });
      print('Error uploading file: $e');
    }
  }

  Future<void> _addBalanceDialog() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Balance'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount to add',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(controller.text) ?? 0;
              setState(() {
                _walletBalance += amount;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _calculateTotalCost() {
    if (_file != null && _selectedCloud != null) {
      setState(() {
        _uploadCost = _calculateUploadCost(_file!.lengthSync(), _selectedCloud!, _days);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Upload",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 125, 177, 127),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_balance_wallet,color: Colors.white,),
            onPressed: _addBalanceDialog,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _pickFile,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 125, 177, 127)),
                ),
                child: const Text('Select File', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              if (_file != null) ...[
                Column(
                  children: _cloudPrices.keys.map((String key) {
                    double cost = _calculateUploadCost(_file!.lengthSync(), key, _days);
                    return ListTile(
                      title: Text(key),
                      subtitle: Text('Upload Cost: ${cost.toStringAsFixed(2)} Rs for $_days days'),
                      trailing: Radio<String>(
                        value: key,
                        groupValue: _selectedCloud,
                        onChanged: (value) {
                          setState(() {
                            _selectedCloud = value;
                            if (_file != null) {
                              _uploadCost = _calculateUploadCost(_file!.lengthSync(), _selectedCloud!, _days);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of days',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _days = int.tryParse(value) ?? 1;
                    _calculateTotalCost();
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Selected File: ${_file!.path.split('/').last}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'File Size: $_fileSize',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_uploadCost != null)
                  Text(
                    'Total Upload Cost: ${_uploadCost!.toStringAsFixed(2)} Rs',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Upload Start Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Upload End Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: _days)))}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Wallet Balance: ${_walletBalance.toStringAsFixed(2)} Rs',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadFile,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 125, 177, 127)),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Upload File', style: TextStyle(color: Colors.white)),
              ),
              if (_uploadMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(_uploadMessage!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
