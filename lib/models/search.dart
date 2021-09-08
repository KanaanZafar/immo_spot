class Search {
  String city;
  int beds;
  int startingPrice;
  int endingPrice;

  Search({this.city, this.beds, this.startingPrice, this.endingPrice});

  @override
  String toString() {
    return 'Search{city: $city, beds: $beds, startingPrice: $startingPrice, endingPrice: $endingPrice}';
  }
}