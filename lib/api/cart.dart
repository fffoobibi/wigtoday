import 'package:wigtoday_app/app/cart/models/cart_item.dart';
import 'package:wigtoday_app/app/home/models/product.dart';

class ApiCart {
  static List<CartItemModel> getCartList() {
    return [
      CartItemModel(
        product: ProductModel(
          id: 1,
          title: 'Lolita Alicegarden Bonnie Pink/Purple Buns Wig Wm1018 Pink/Purple Buns Wig Wm1018 Bonnie',
          imageUrl: 'https://placeimg.com/310/310/any1',
          realPrice: 11.0,
          rawPrice: 15.9,
          score: 5,
          sizes: [
            ProductSizeModel(
              title: 'Hair Length',
              options: [
                {'id': 213, 'value': '14'},
                {'id': 214, 'value': '16'},
                {'id': 215, 'value': '18'},
                {'id': 216, 'value': '20'},
                {'id': 217, 'value': '22'},
                {'id': 218, 'value': '24'},
                {'id': 219, 'value': '26'},
              ],
            ),
          ],
        ),
        maxQuantity: 5,
      ),
      CartItemModel(
          product: ProductModel(
            id: 2,
            title: 'Short Pink Straight Wig Wm1104 Pink/Purple Buns Wig Wm1018 Bonnie Hgfid ReBuild List',
            imageUrl: 'https://placeimg.com/310/310/any2',
            realPrice: 124.0,
            rawPrice: 158.3,
            score: 3,
            sizes: [
              ProductSizeModel(
                title: 'Hair Length',
                options: [
                  {'id': 213, 'value': '14'},
                  {'id': 214, 'value': '16'},
                  {'id': 215, 'value': '18'},
                  {'id': 216, 'value': '20'},
                  {'id': 217, 'value': '22'},
                  {'id': 218, 'value': '24'},
                  {'id': 219, 'value': '26'},
                ],
              ),
              ProductSizeModel(
                title: 'Lace Design',
                options: [
                  {'id': 23, 'value': '4*4 LACE CLOSURE WIG'},
                  {'id': 24, 'value': '3*4 HAIR WIG'},
                  {'id': 25, 'value': '2*3 ASDRE HAIR'},
                  {'id': 26, 'value': '5*5 JHGT LKJR'},
                ],
              ),
            ],
          ),
          minQuantity: 5,
          maxQuantity: 8,
          initQuantity: 3
      ),
      CartItemModel(
        product: ProductModel(
          id: 3,
          title: 'Kuytrhitg per Light Dintjhifd Finds a Tfrefbchd fhroioy Pink/Purple Buns Wig Wm1018 Bonnie',
          imageUrl: 'https://placeimg.com/310/310/any3',
          realPrice: 21.5,
          rawPrice: 35.9,
          score: 4,
          sizes: [
            ProductSizeModel(
              title: 'Hair Length',
              options: [
                {'id': 213, 'value': '14'},
                {'id': 214, 'value': '16'},
                {'id': 215, 'value': '18'},
                {'id': 216, 'value': '20'},
                {'id': 217, 'value': '22'},
                {'id': 218, 'value': '24'},
                {'id': 219, 'value': '26'},
              ],
            ),
            ProductSizeModel(
              title: 'Lace Design',
              options: [
                {'id': 23, 'value': '4*4 LACE CLOSURE WIG'},
                {'id': 24, 'value': '3*4 HAIR WIG'},
                {'id': 25, 'value': '2*3 ASDRE HAIR'},
                {'id': 26, 'value': '5*5 JHGT LKJR'},
              ],
            ),
          ],
        ),
        minQuantity: 10,
        maxQuantity: -1,
      ),
      CartItemModel(
        product: ProductModel(
          id: 3,
          title: 'Kuytrhitg per Light Dintjhifd Finds a Tfrefbchd fhroioy Pink/Purple Buns Wig Wm1018 Bonnie',
          imageUrl: 'https://placeimg.com/310/310/any3',
          realPrice: 21.5,
          rawPrice: 35.9,
          score: 4,
          sizes: [
            ProductSizeModel(
              title: 'Hair Length',
              options: [
                {'id': 213, 'value': '14'},
                {'id': 214, 'value': '16'},
                {'id': 215, 'value': '18'},
                {'id': 216, 'value': '20'},
                {'id': 217, 'value': '22'},
                {'id': 218, 'value': '24'},
                {'id': 219, 'value': '26'},
              ],
            ),
            ProductSizeModel(
              title: 'Lace Design',
              options: [
                {'id': 23, 'value': '4*4 LACE CLOSURE WIG'},
                {'id': 24, 'value': '3*4 HAIR WIG'},
                {'id': 25, 'value': '2*3 ASDRE HAIR'},
                {'id': 26, 'value': '5*5 JHGT LKJR'},
              ],
            ),
          ],
        ),
        minQuantity: 10,
        maxQuantity: -1,
      ),
      CartItemModel(
        product: ProductModel(
          id: 1,
          title: 'Lolita Alicegarden Bonnie Pink/Purple Buns Wig Wm1018 Pink/Purple Buns Wig Wm1018 Bonnie',
          imageUrl: 'https://placeimg.com/310/310/any1',
          realPrice: 11.0,
          rawPrice: 15.9,
          score: 5,
          sizes: [
            ProductSizeModel(
              title: 'Hair Length',
              options: [
                {'id': 213, 'value': '14'},
                {'id': 214, 'value': '16'},
                {'id': 215, 'value': '18'},
                {'id': 216, 'value': '20'},
                {'id': 217, 'value': '22'},
                {'id': 218, 'value': '24'},
                {'id': 219, 'value': '26'},
              ],
            ),
          ],
        ),
        maxQuantity: 5,
      ),
    ];
  }
}