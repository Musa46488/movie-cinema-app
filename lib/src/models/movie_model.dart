class MoviesModel {
  final String id;
  final String url;
  final String title;
  final String originalTitle;
  final String description;
  final String image;
  final List<String> thumbnails;
  final String trailer;
  final String contentRating;
  final int startYear;
  final String releaseDate;
  final List<String> genres;
  final double averageRating;
  final int runtimeMinutes;
  final int numVotes;
  final String? productionCompany;

  MoviesModel({
    required this.id,
    required this.url,
    required this.title,
    required this.originalTitle,
    required this.description,
    required this.image,
    required this.thumbnails,
    required this.trailer,
    required this.contentRating,
    required this.startYear,
    required this.releaseDate,
    required this.genres,
    required this.averageRating,
    required this.runtimeMinutes,
    required this.numVotes,
    required this.productionCompany,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> json) {
    return MoviesModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      title: json['primaryTitle'] ?? '',
      originalTitle: json['originalTitle'] ?? '',
      description: json['description'] ?? '',
      image: json['primaryImage'] ?? '',
      thumbnails:
          (json['thumbnails'] as List<dynamic>?)
              ?.map((thumb) => thumb['url'] as String)
              .toList() ??
          [],
      trailer: json['trailer'] ?? '',
      contentRating: json['contentRating'] ?? 'N/A',
      startYear: json['startYear'] ?? 0,
      releaseDate: json['releaseDate'] ?? '',
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g.toString())
              .toList() ??
          [],
      averageRating: (json['averageRating'] is num)
          ? json['averageRating'].toDouble()
          : 0.0,
      runtimeMinutes: json['runtimeMinutes'] ?? 0,
      numVotes: json['numVotes'] ?? 0,
      productionCompany:
          (json['productionCompanies'] != null &&
              (json['productionCompanies'] as List).isNotEmpty)
          ? json['productionCompanies'][0]['name']
          : null,
    );
  }
}
