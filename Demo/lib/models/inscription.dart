class Inscription {
  final String nom;
  final String prenom;
  final String classe;
  final String matricule;
  final String email;

  Inscription({
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.matricule,
    required this.email,
  });

  factory Inscription.fromJson(Map<String, dynamic> json) {
    return Inscription(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      classe: json['classe'] ?? 'Non spécifiée',
      matricule: json['matricule'] ?? '',
      email: json['email'] ?? '',
    );
  }

  String get fullName => '$prenom $nom';
}