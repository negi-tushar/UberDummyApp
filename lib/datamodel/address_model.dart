class Address {
  late String placeName;
  late double lat;
  late double long;
  late String placeId;
  late String formatedAddress;
  Address({
    required this.placeName,
    required this.formatedAddress,
    required this.lat,
    required this.long,
    required this.placeId,
  });
}
