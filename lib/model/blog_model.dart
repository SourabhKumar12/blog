class BlogModel {
  String? id;
  String? imageurl;
  String? title;
  bool isFavorite;

  BlogModel({this.id, this.imageurl, this.title, this.isFavorite = false});

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      imageurl: json['image_url'],
      title: json['title'],
    );
  }
}
