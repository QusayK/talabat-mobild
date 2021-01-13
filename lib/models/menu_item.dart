class MenuItem {
  int id;
  int rest_id;
  String name;
  String descr;
  var price;
  String image;
  var rating;

  MenuItem(
      {this.id,
      this.rest_id,
      this.name,
      this.descr,
      this.price,
      this.image,
      this.rating});

  static final columns = [
    'id',
    'rest_id',
    'name',
    'descr',
    'price',
    'image',
    'rating'
  ];

  factory MenuItem.fromJson(dynamic json) {
    return MenuItem(
        id: json['id'],
        rest_id: json['rest_id'],
        name: json['name'],
        descr: json['descr'],
        price: json['price'],
        image: 'http://appback.ppu.edu/static/${json['image']}',
        rating: json['rating']);
  }

  factory MenuItem.fromMap(Map<String, dynamic> data) {
    return MenuItem(
        id: data['id'],
        rest_id: data['rest_id'],
        name: data['name'],
        descr: data['descr'],
        price: data['price'],
        image: data['image'],
        rating: data['rating']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "rest_id": rest_id,
      "name": name,
      "descr": descr,
      "price": price,
      "image": image,
      "rating": rating
    };
  }
}
