import 'dart:convert';
import 'package:app3/services/constant.dart';
import 'package:app3/services/database.dart';
import 'package:app3/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app3/widget/support_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  String image, name, detail, price;
  ProductDetail(
      {required this.detail,
      required this.image,
      required this.name,
      required this.price});
  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;

  // Lấy thông tin từ SharedPreferences
  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    if (name == null || mail == null || image == null) {
      print("Thông tin người dùng bị thiếu.");
      // Xử lý trường hợp thông tin người dùng không đầy đủ
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Không thể tiếp tục do thiếu thông tin người dùng."),
      ));
    }
    setState(() {});
  }

  // Gọi hàm để load thông tin khi khởi tạo
  ontheload() async {
    await getthesharedpref();
  }

  @override
  void initState() {
    super.initState();
    ontheload(); // Khởi chạy hàm lấy thông tin từ SharedPreferences
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.arrow_back_ios_new_outlined)),
              ),
              Center(
                child: Image.network(
                  widget.image,
                  height: 400,
                ),
              )
            ]),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 10.0, right: 20.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        Text("đ" + widget.price,
                            style: const TextStyle(
                                color: Color(0xFFfd6f3e),
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Chi tiết",
                      style: AppWidget.semiboldTextFeildStyle(),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.detail,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 90.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Mua Ngay tapped");
                        if (name != null && mail != null && image != null) {
                          makePayment(widget.price);
                        } else {
                          print("Không thể thanh toán do thiếu thông tin người dùng");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFfd6f3e),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                            child: Text(
                          "Mua Ngay",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await creatPaymentIntent(amount, 'VND');
      if (paymentIntent != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent?['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Adman',
        ));
        dispalPaymentSheet();
      } else {
        throw Exception("Error creating payment intent");
      }
    } catch (e, s) {
      print('exception: $e, $s');
    }
  }

  dispalPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfomap = {
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": mail, // Đã lấy từ SharedPreferences
          "Image": image,
          "ProductImage": widget.image,
          "Status":"Đang được ship"
        };
        await DatabaseMethods().orderDetails(orderInfomap);
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          const Text("Thanh toán thành công")
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error is: $error $stackTrace");
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Text("Lỗi hiển thị thanh toán: $error"),
                ));
      });
    } on StripeException catch (e) {
      print("Error is: $e");
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Thanh toán đã bị hủy."),
              ));
    } catch (e) {
      print("General error: $e");
    }
  }

  creatPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to create payment intent: ${response.body}");
        throw Exception("Failed to create payment intent");
      }
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    try {
      final amountValue = int.parse(amount.replaceAll(RegExp(r'[^\d]'), ''));
      final calculateAmount = amountValue * 100; // Chuyển đổi sang cents
      if (calculateAmount > 99999999) {
        print('Amount exceeds limit for Stripe');
        return '99999999';
      }
      return calculateAmount.toString();
    } catch (e) {
      print('Error parsing amount: $e');
      return '0'; // Mặc định 0 nếu gặp lỗi
    }
  }
}
