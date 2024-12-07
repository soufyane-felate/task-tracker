import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suivi des tâches',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TaskTrackerMainScreen(userName: 'Utilisateur'),
    );
  }
}

class TaskTrackerMainScreen extends StatefulWidget {
  final String userName;

  const TaskTrackerMainScreen({super.key, required this.userName});

  @override
  _TaskTrackerMainScreenState createState() => _TaskTrackerMainScreenState();
}

class _TaskTrackerMainScreenState extends State<TaskTrackerMainScreen> {
  final List<Map<String, String>> activities = [];

  final List<String> filiereOptions = ['Agrumes', 'Céréales', 'Légumes'];

  final Map<String, List<String>> projetFilter = {
    'Agrumes': ['Projet A', 'Projet C'],
    'Céréales': ['Projet B', 'Projet D'],
    'Légumes': ['Projet E', 'Projet F'],
  };

  final Map<String, List<String>> axeFilter = {
    'Projet A': ['Axe 1', 'Axe 2'],
    'Projet B': ['Axe 3', 'Axe 4'],
    'Projet C': ['Axe 5', 'Axe 6'],
    'Projet D': ['Axe 7', 'Axe 8'],
    'Projet E': ['Axe 9', 'Axe 10'],
    'Projet F': ['Axe 11', 'Axe 12'],
  };

  final Map<String, List<String>> activiteFilter = {
    'Axe 1': ['Activité A', 'Activité B'],
    'Axe 2': ['Activité C', 'Activité D'],
    'Axe 3': ['Activité E', 'Activité F'],
    'Axe 4': ['Activité G', 'Activité H'],
    'Axe 5': ['Activité I', 'Activité J'],
    'Axe 6': ['Activité B', 'Activité E'],
    'Axe 7': ['Activité H', 'Activité J'],
  };

  final TextEditingController _filiereController = TextEditingController();
  final TextEditingController _projetController = TextEditingController();
  final TextEditingController _axeController = TextEditingController();
  final TextEditingController _activiteController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();

  String? _selectedDate;
  List<String> projetOptions = [];
  List<String> axeOptions = [];
  List<String> activiteOptions = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    setState(() {
      projetOptions = [];
      axeOptions = [];
      activiteOptions = [];
      _filiereController.clear();
      _projetController.clear();
      _axeController.clear();
      _activiteController.clear();
    });
  }

  void _updateProjetOptions(String selectedFiliere) {
    setState(() {
      projetOptions = projetFilter[selectedFiliere] ?? [];
      axeOptions = [];
      activiteOptions = [];
      _projetController.clear();
      _axeController.clear();
      _activiteController.clear();
    });
  }

  void _updateAxeOptions(String selectedProjet) {
    setState(() {
      axeOptions = axeFilter[selectedProjet] ?? [];
      activiteOptions = [];
      _axeController.clear();
      _activiteController.clear();
    });
  }

  void _updateActiviteOptions(String selectedAxe) {
    setState(() {
      activiteOptions = activiteFilter[selectedAxe] ?? [];
      _activiteController.clear();
    });
  }

  void _clearFields() {
    _initializeFields();
    _timeController.clear();
    _percentageController.clear();
    _commentaireController.clear();
    _selectedDate = null;
  }

  void _addActivity() {
    if (_filiereController.text.isNotEmpty &&
        _projetController.text.isNotEmpty &&
        _axeController.text.isNotEmpty &&
        _activiteController.text.isNotEmpty &&
        _selectedDate != null &&
        _timeController.text.isNotEmpty &&
        _percentageController.text.isNotEmpty &&
        _commentaireController.text.isNotEmpty) {
      setState(() {
        activities.add({
          'Filière': _filiereController.text,
          'Projet': _projetController.text,
          'Axe': _axeController.text,
          'Activité': _activiteController.text,
          'Date': _selectedDate!,
          'Temps': _timeController.text,
          'Pourcentage': _percentageController.text,
          'Commentaire': _commentaireController.text,
        });
      });
      _clearFields();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Veuillez remplir tous les champs et sélectionner une date.'),
        ),
      );
    }
  }

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

  Widget _buildSearchableDropdown({
    required String label,
    required TextEditingController controller,
    required List<String> options,
    required void Function(String) onChanged,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: enabled ? 'Rechercher ou sélectionner...' : 'Désactivé',
            suffixIcon: enabled
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      controller.text = value;
                      onChanged(value);
                    },
                    itemBuilder: (context) => options
                        .map((option) => PopupMenuItem(
                              value: option,
                              child: Text(option),
                            ))
                        .toList(),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _showAddActivityModal(BuildContext context) {
    _initializeFields();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
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
                const Text(
                  'Ajouter une nouvelle activité',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildSearchableDropdown(
                  label: 'Filière',
                  controller: _filiereController,
                  options: filiereOptions,
                  onChanged: (value) => _updateProjetOptions(value),
                  enabled: true,
                ),
                const SizedBox(height: 10),
                _buildSearchableDropdown(
                  label: 'Projet',
                  controller: _projetController,
                  options: projetOptions,
                  onChanged: (value) => _updateAxeOptions(value),
                  enabled: _filiereController.text.isNotEmpty,
                ),
                const SizedBox(height: 10),
                _buildSearchableDropdown(
                  label: 'Axe',
                  controller: _axeController,
                  options: axeOptions,
                  onChanged: (value) => _updateActiviteOptions(value),
                  enabled: _projetController.text.isNotEmpty,
                ),
                const SizedBox(height: 10),
                _buildSearchableDropdown(
                  label: 'Activité',
                  controller: _activiteController,
                  options: activiteOptions,
                  onChanged: (_) {},
                  enabled: _axeController.text.isNotEmpty,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate ?? 'Aucune date sélectionnée',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: 'Temps',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _percentageController,
                        decoration: const InputDecoration(
                          labelText: 'Pourcentage',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentaireController,
                  decoration: const InputDecoration(
                    labelText: 'Commentaire',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addActivity,
                  child: const Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
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
        title: const Text('Suivi des tâches'),
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
                'Bienvenue, ${widget.userName}!',
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
                ? const Center(
                    child: Text('Aucune activité ajoutée pour l\'instant'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Filière')),
                        DataColumn(label: Text('Projet')),
                        DataColumn(label: Text('Axe')),
                        DataColumn(label: Text('Activité')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Temps')),
                        DataColumn(label: Text('Pourcentage')),
                        DataColumn(label: Text('Commentaire')),
                      ],
                      rows: activities.map((activity) {
                        return DataRow(cells: [
                          DataCell(Text(activity['Filière']!)),
                          DataCell(Text(activity['Projet']!)),
                          DataCell(Text(activity['Axe']!)),
                          DataCell(Text(activity['Activité']!)),
                          DataCell(Text(activity['Date']!)),
                          DataCell(Text(activity['Temps']!)),
                          DataCell(Text(activity['Pourcentage']!)),
                          DataCell(Text(activity['Commentaire']!)),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityModal(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
