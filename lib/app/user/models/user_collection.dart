class UserCollectionModel {
  int id; // 60052,
  String product_name; // "LOLITA PINK AIR BANGS STRAIGHT WIG WM1226",
  String net_price; // "EUR 35.94",
  String price; // "EUR 42.39",
  String currency; // "EUR",
  String currency_symbol; // "€",
  String net_price_symbol; // "€ 35.94",
  String net_price_o; // "35.94",
  String price_o; // "42.39",
  String detail_url; // "lolita-pink-air-bangs-straight-wig-wm1226.html",
  String
      image; // "https://filetest.mediamzshop.com/product/7a527873c6fc431b1d78a16d12775f16_thumb.jpg"

  UserCollectionModel({
    required this.id,
    required this.product_name,
    required this.net_price,
    required this.price,
    required this.currency,
    required this.currency_symbol,
    required this.net_price_symbol,
    required this.net_price_o,
    required this.price_o,
    required this.detail_url,
    required this.image,
  });

  static UserCollectionModel fromReponse(Map<String, dynamic> data) {
    return UserCollectionModel(
      id: data['id'], // 60052,
      product_name:
          data['product_name'], // "LOLITA PINK AIR BANGS STRAIGHT WIG WM1226",
      net_price: data['net_price'], // "EUR 35.94",
      price: data['price'], // "EUR 42.39",
      currency: data['currency'], // "EUR",
      currency_symbol: data['currency_symbol'], // "€",
      net_price_symbol: data['net_price_symbol'], // "€ 35.94",
      net_price_o: data['net_price_o'], // "35.94",
      price_o: data['price_o'], // "42.39",
      detail_url: data['detail_url'], // "lolita-pink-air-bangs-straight-wig-wm1226.html",
      image: data['image'],
    );
  }

   static List<UserCollectionModel> fromList(List<dynamic> datas) {
     final res = List.generate(datas.length, (index) => fromReponse(datas[index] as Map<String, dynamic>));
     return res;
  }
}
