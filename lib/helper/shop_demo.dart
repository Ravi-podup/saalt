import 'package:saalt/helper/product_helper.dart';
import 'package:saalt/models/product.dart';

/// One line in the static cart.
class CartLine {
  const CartLine({
    required this.productName,
    required this.variant,
    required this.quantity,
  });

  final String productName;

  /// The resolved choice, as it reads on a receipt.
  final String variant;

  final int quantity;

  Product get product =>
      ProductHelper.catalog.firstWhere((p) => p.name == productName);

  double get lineTotal => product.price * quantity;
}

/// One past order. Carries its real lines, so a row can show what was in it
/// and the totals cannot drift from the products.
class DemoOrder {
  const DemoOrder({
    required this.reference,
    required this.placed,
    required this.status,
    required this.lines,
  });

  final String reference;
  final String placed;
  final OrderStatus status;
  final List<CartLine> lines;

  int get items => lines.fold(0, (sum, line) => sum + line.quantity);

  double get total => lines.fold(0, (sum, line) => sum + line.lineTotal);
}

enum OrderStatus {
  delivered('Delivered'),
  onItsWay('On its way'),
  packing('Packing');

  const OrderStatus(this.label);

  final String label;
}

/// Fixed content for the shop screens. These screens are designs, so the cart,
/// the saved list and the order history are stated here rather than tracked —
/// the arithmetic is still done properly, because a wrong total on a mock is
/// worse than no total.
class ShopDemo {
  ShopDemo._();

  static const cart = <CartLine>[
    CartLine(
      productName: 'Saalt Cup',
      variant: 'Regular · Himalayan Pink',
      quantity: 1,
    ),
    CartLine(
      productName: 'Leakproof Seamless Brief',
      variant: 'Medium · Soft Sand',
      quantity: 2,
    ),
    CartLine(productName: 'Saalt Cup Wash', variant: '100 ml', quantity: 1),
  ];

  static const savedNames = <String>[
    'Leakproof Comfort CloudShort',
    'Saalt Soft Cup',
    'Saalt Disc',
    'Leakproof Seamless Thong',
  ];

  static List<Product> get saved => [
    for (final name in savedNames)
      ...ProductHelper.catalog.where((p) => p.name == name),
  ];

  static const orders = <DemoOrder>[
    DemoOrder(
      reference: 'SA-4821',
      placed: '2 Sep',
      status: OrderStatus.onItsWay,
      lines: [
        CartLine(
          productName: 'Saalt Cup',
          variant: 'Regular · Himalayan Pink',
          quantity: 1,
        ),
        CartLine(
          productName: 'Leakproof Seamless Brief',
          variant: 'Medium · Soft Sand',
          quantity: 2,
        ),
      ],
    ),
    DemoOrder(
      reference: 'SA-4610',
      placed: '14 Aug',
      status: OrderStatus.delivered,
      lines: [
        CartLine(productName: 'Saalt Disc', variant: 'One size', quantity: 1),
      ],
    ),
    DemoOrder(
      reference: 'SA-4477',
      placed: '29 Jul',
      status: OrderStatus.delivered,
      lines: [
        CartLine(productName: 'Saalt Cup Wash', variant: '100 ml', quantity: 1),
        CartLine(
          productName: 'Saalt Steamer',
          variant: 'One size',
          quantity: 1,
        ),
        CartLine(
          productName: 'Leakproof Seamless Thong',
          variant: 'Small · Black',
          quantity: 1,
        ),
      ],
    ),
  ];

  static int get cartCount => cart.fold(0, (sum, line) => sum + line.quantity);

  static double get subtotal =>
      cart.fold(0, (sum, line) => sum + line.lineTotal);

  /// Free over sixty, which is the sort of threshold these shops run.
  static const freeShippingFrom = 60.0;

  static double get shipping => subtotal >= freeShippingFrom ? 0 : 4.95;

  static double get total => subtotal + shipping;

  static const address = (
    name: 'Giorgia Meloni',
    line1: '14 Kalyani Nagar',
    line2: 'Pune, Maharashtra 411006',
  );

  static const deliveryEstimate = 'Thu 11 – Sat 13 Sep';
}
