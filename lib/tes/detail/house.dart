class House {
  String name;
  String address;
  String imageUrl;

  House(this.name, this.address, this.imageUrl);

  static List<House> generateRecommended() {
    return [
      House('Toyata Alphard', 'VIP Class',
      'assets/img/alphard2.jpeg'),
       House('Toyota Avanza', 'Reguler Class',
      'assets/img/avanza2.jpg'),
    ];
  }

  static List<House> generateBestOffer() {
    return [
       House('Pantai Papuma', 'Jawa Timur , Jember',
      'assets/img/papuma.jpg'),
       House('Wisata Bukit Simbat' , 'Jawa Timur, Jember',
      'assets/img/simbat.jpg'),
      House('Air Terjun Tancak Tulis' , 'Jawa Timur, Jember',
      'assets/img/tancaktulis.jpg'),
      House('Pantai Teluk Love', 'Jawa Timur, Jember',
      'assets/img/teluklove.jpg'),
      House('Bukit Diatas Awan' , 'Jawa Timur, Jember',
      'assets/img/J88.jpg')
    ];
  }
}