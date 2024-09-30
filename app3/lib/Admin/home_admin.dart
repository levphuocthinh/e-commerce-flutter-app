import 'package:app3/Admin/add_product.dart';
import 'package:app3/Admin/all_order.dart';
import 'package:app3/widget/support_widget.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        centerTitle: true,
        title: Text(
          "Home Admin",
          style: AppWidget.boldTextFeildStyle().copyWith(
            fontSize: 24.0,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(children: [
          SizedBox(height: 50.0,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
            },
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 10.0,right: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 50.0,
                    ),
                    SizedBox(width:20.0 ,),
                    Text(
                      "Add Product",
                      style: AppWidget.boldTextFeildStyle(),
                    )
                  ],
                ),
              ),
            ),
          ),
           SizedBox(height: 80.0,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AllOrder()));
            },
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 10.0,right: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 50.0,
                    ),
                    SizedBox(width:20.0 ,),
                    Text(
                      "All Orders",
                      style: AppWidget.boldTextFeildStyle(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
