import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/inscription.dart';

class InscriptionView extends StatefulWidget {
  const InscriptionView({Key? key}) : super(key: key);

  @override
  _InscriptionViewState createState() => _InscriptionViewState();
}

class _InscriptionViewState extends State<InscriptionView> {
  final ApiService _apiService = ApiService();
  Future<List<Inscription>>? _futureInscriptions;
  String? _selectedClasse;
  final List<String> _allClasses = ['L1 MAE', 'L2 INFO', 'L3 MIAGE'];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _futureInscriptions = _apiService.getAllInscriptions();
    });
  }

  void _filterByClass(String? classe) {
    setState(() {
      _selectedClasse = classe;
      _futureInscriptions = classe == null
          ? _apiService.getAllInscriptions()
          : _apiService.getInscriptionsByClass(classe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        actions: [
          _buildClassFilterDropdown(),
        ],
      ),
      body: FutureBuilder<List<Inscription>>(
        future: _futureInscriptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          return _buildStudentList(snapshot.data ?? []);
        },
      ),
    );
  }

  Widget _buildClassFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedClasse,
      hint: const Text('Toutes classes'),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('Toutes classes'),
        ),
        ..._allClasses.map((classe) {
          return DropdownMenuItem(
            value: classe,
            child: Text(classe),
          );
        }),
      ],
      onChanged: _filterByClass,
    );
  }

  Widget _buildStudentList(List<Inscription> inscriptions) {
    // Grouper par classe
    final Map<String, List<Inscription>> grouped = {};
    for (var ins in inscriptions) {
      grouped.putIfAbsent(ins.classe, () => []).add(ins);
    }

    return ListView(
      children: [
        for (var entry in grouped.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Classe ${entry.key}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ...entry.value.map((student) => _buildStudentCard(student)),
            ],
          ),
      ],
    );
  }

  Widget _buildStudentCard(Inscription student) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('${student.prenom} ${student.nom}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Matricule: ${student.matricule}'),
            Text('Email: ${student.email}'),
          ],
        ),
      ),
    );
  }
}