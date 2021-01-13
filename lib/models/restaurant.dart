class Restaurant {
  int id;
  String name;
  String city;
  String lat;
  String lng;
  String phone;
  String image;
  int rating;

  Restaurant(
      {this.id,
      this.name,
      this.city,
      this.lat,
      this.lng,
      this.phone,
      this.image,
      this.rating});

  factory Restaurant.fromJson(dynamic json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      lat: json['lat'],
      lng: json['lng'],
      phone: json['phone'],
      image: 'http://appback.ppu.edu/static/${json['image']}',
      rating: json['rating'],
    );
  }
}
