// import 'dart:ffi';
import 'package:app3/pages/category_products.dart';
import 'package:app3/pages/product_detail.dart';
import 'package:app3/services/database.dart';
import 'package:app3/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app3/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List The_Loai = [
    "images/headphone.png",
    "images/apple.png",
    "images/laptop.png",
    "images/television.png",
  ];
  List Categoryname = [
    "Tai Nghe",
    "Đồng Hồ",
    "LAPTOP",
    "TV",
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller= new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  String? name, image;

  getthesharedprefas() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedprefas();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Xin Chào," + name!,
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                            Text(
                              "Xin Chào Buổi Sáng 🌞",
                              style: AppWidget.lightTextFeildStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              //dkm nó cay Image.network
                              image!,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchcontroller,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Tìm kiếm sản phẩm",
                            hintStyle: AppWidget.lightTextFeildStyle(),
                            prefixIcon: search? GestureDetector(
                              onTap: (){
                                search=false;
                                tempSearchStore=[];
                                queryResultSet=[];
                                searchcontroller.text="";//code tới đây rồi
                                setState(() {
                                  
                                });

                              },
                              child: Icon(Icons.close)): Icon(
                              
                              Icons.search,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Danh mục sản phẩm",
                                        style:
                                            AppWidget.semiboldTextFeildStyle()),
                                    Text("Xem thêm",
                                        style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                      height: 120,
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.only(right: 20.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFD6F3E),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                          child: Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ))),
                                  Expanded(
                                    child: SizedBox(
                                      // margin: EdgeInsets.only(left: 20.0),
                                      height: 130,
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: The_Loai.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return CategoryTile(
                                              image: The_Loai[index],
                                              name: Categoryname[index],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Tất cả sản phẩm",
                                      style:
                                          AppWidget.semiboldTextFeildStyle()),
                                  Text("Xem thêm",
                                      style: TextStyle(
                                          color: Color(0xFFfd6f3e),
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: 220,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "images/headphone-bluetooth-beats-powerbeatspro-3kshop-7-removebg-preview.png",
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Powerbeats Pro",
                                            style: AppWidget
                                                .semiboldTextFeildStyle(),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "5.000.000đ",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFfd6f3e),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "images/apple-watch-ultra-lte-49mm-vien-titanium-day-ocean-cam-tb-1-650x650.png",
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Apple Watch Ultra 2 GPS",
                                            style: AppWidget
                                                .semiboldTextFeildStyle(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "21.190.000₫",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFfd6f3e),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: const Icon(
                                                   Icons.add,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "images/macbook-air-15-inch-m3-2024-xanh-650x650.png",
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "MacBook Air 15 inch M3",
                                            style: AppWidget
                                                .semiboldTextFeildStyle(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "31.390.000₫",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFfd6f3e),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "images/tai-nghe-bluetooth-beats-solo-4-hong-1-650x650.jpg",
                                            height: 150,
                                            width: 160,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Tai Nghe Beats Solo 4",
                                            style: AppWidget
                                                .semiboldTextFeildStyle(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "4.990.000₫",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFfd6f3e),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(right: 20.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "images/x77l.jpg",
                                            height: 150,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            "Google Tivi Sony 4K 55 inch",
                                            style: AppWidget
                                                .semiboldTextFeildStyle(),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "13.990.000₫",
                                                style: TextStyle(
                                                    color: Color(0xFFfd6f3e),
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFfd6f3e),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17)),
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                    detail: data["Detail"],
                    image: data["Image"],
                    name: data["Name"],
                    price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data["Image"],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiboldTextFeildStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProducts(category: name)));
      },
      child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                image,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              // SizedBox(height: 10.0,),
              const Icon(Icons.arrow_forward) //đang code tới đây
            ],
          )),
    );
  }
}
