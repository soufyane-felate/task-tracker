import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTrackerMainScreen extends StatefulWidget {
  final String userName;

  const TaskTrackerMainScreen({super.key, required this.userName});
  @override
  _TaskTrackerMainScreenState createState() => _TaskTrackerMainScreenState();
}

class _TaskTrackerMainScreenState extends State<TaskTrackerMainScreen> {
  final List<Map<String, String>> activities = [];
  String selectedFiliere = 'Agrumes';

  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _axeController = TextEditingController();
  final TextEditingController _crraController = TextEditingController();
  final TextEditingController _coordinatorController = TextEditingController();
  String? _selectedDate;
  String? _selectedFiliereForModal =
      'Agrumes'; 
  // Function to clear input fields
  void _clearFields() {
    _activityController.clear();
    _axeController.clear();
    _crraController.clear();
    _coordinatorController.clear();
    _selectedDate = null;
    _selectedFiliereForModal = 'Agrumes';
  }

  // Function to add a new activity
  void _addActivity() {
    if (_activityController.text.isNotEmpty &&
        _axeController.text.isNotEmpty &&
        _crraController.text.isNotEmpty &&
        _coordinatorController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedFiliereForModal != null) {
      setState(() {
        activities.add({
          'filiere': _selectedFiliereForModal!, 
          'activity': _activityController.text,
          'axe': _axeController.text,
          'crra': _crraController.text,
          'coordinator': _coordinatorController.text,
          'date': _selectedDate!,
        });
      });
      _clearFields();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a date')),
      );
    }
  }

  // Function to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Function to show modal for adding activity
  void _showAddActivityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedFiliereForModal,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Filiere',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedFiliereForModal = value!;
                    });
                  },
                  items: ['Agrumes', 'Other Filiere', 'Vegetables', 'Cereals']
                      .map((filiere) {
                    return DropdownMenuItem<String>(
                      value: filiere,
                      child: Text(filiere),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _activityController,
                  decoration: InputDecoration(
                    labelText: 'Activity',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _axeController,
                  decoration: InputDecoration(
                    labelText: 'Axe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _crraController,
                  decoration: InputDecoration(
                    labelText: 'CRRA',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _coordinatorController,
                  decoration: InputDecoration(
                    labelText: 'Coordinator',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate ?? 'No date selected',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addActivity,
                  child: Text('Add Activity'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Card(
            color: const Color.fromARGB(255, 77, 190, 235),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, ${widget.userName}!',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: activities.isEmpty
                ? Center(child: Text('No activities added yet'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Filiere')),
                        DataColumn(label: Text('Activity')),
                        DataColumn(label: Text('AXE')),
                        DataColumn(label: Text('CRRA')),
                        DataColumn(label: Text('Coordinator')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: activities.map((activity) {
                        return DataRow(cells: [
                          DataCell(Text(activity['filiere']!)),
                          DataCell(Text(activity['activity']!)),
                          DataCell(Text(activity['axe']!)),
                          DataCell(Text(activity['crra']!)),
                          DataCell(Text(activity['coordinator']!)),
                          DataCell(Text(activity['date']!)),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityModal(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
