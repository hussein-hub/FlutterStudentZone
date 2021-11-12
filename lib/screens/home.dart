import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentzone/screens/productdetail.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_pro/carousel_pro.dart';

ScrollController mycontroller = ScrollController();
bool closetopcontainer = false;

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mycontroller.addListener(() {
      setState(() {
        closetopcontainer = mycontroller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('product');
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red, title: Text("StudentZone")),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            height: closetopcontainer ? 0 : 230,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                // viewportFraction: 0.8,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(milliseconds: 2500),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(horizontal: 0.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/logo.png"),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              height: 120,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                            Icons.science_outlined,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.library_books,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.construction,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.checkroom_outlined,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.science_outlined,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          Expanded(
            child: StreamBuilder(
              // child:_buildImageSlider(),
              stream:
                  FirebaseFirestore.instance.collection('product').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading....');

                return GridView.builder(
                  controller: mycontroller,
                  // itemExtent: 80.0,
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) => _buildListItem(
                      context, (snapshot.data! as QuerySnapshot).docs[index]),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 8.0 / 10.0,
                    crossAxisCount: 2,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// @override

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    DocumentSnapshot doc = document;
    double width, height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var price = document['price'];
    var name = document['Name'];
    // var img = Image.network(document['image']);
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => productdetail(
                      price: price, name: name, image: document['image']),
                ),
              )

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => new ProductDetail(doc),
              //   ),
              // )
            },
        child: Card(
          child: Container(
            height: height * 0.3,
            width: width * 0.2 * 2 + 10,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(document['image']),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "\Rs ${price.toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff9b96d6)),
                      ),
                      Container(
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// Widget _buildImageSlider() {
//     var height;
//     return Container(
//       height: height * 0.3,
//       child: Carousel(
//         autoplay: true,
//         showIndicator: false,
//         images: [
//           AssetImage("images/man.jpg"),
//           AssetImage("images/women.jpg"),
//           AssetImage("images/camera.jpg"),
//         ],
//       ),
//     );
//   }

class ProductDetail extends StatelessWidget {
  DocumentSnapshot document;

  ProductDetail(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${document['Name']}"),
      ),
      body: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    // width: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(document['image']),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "\Rs ${document['price'].toString()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xff9b96d6)),
                    ),
                    Container(
                      child: Text(
                        document['Name'],
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
