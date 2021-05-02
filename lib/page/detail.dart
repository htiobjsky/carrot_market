import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market/components/manor_temperature_widget.dart';
import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView({Key key, this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  Size size;
  List<String> imgList;
  int _current;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    _current = 0;
    imgList = [
      widget.data["image"],
      widget.data["image"],
      widget.data["image"],
      widget.data["image"],
      widget.data["image"],
    ];
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  Widget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        IconButton(
            icon: Icon(Icons.share, color: Colors.white), onPressed: () {}),
        IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
      ],
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderImage(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(50),
          //   child: Container(
          //     width: 50,
          //     height: 50,
          //     child: Image.asset('assets/images/user.png'),
          //   ),
          // ),
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset('assets/images/user.png').image,
            // child: Image.asset('assets/images/user.png'),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("BJSKY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              Text("서울시 반포동"),
            ],
          ),
          Expanded(child: ManorTemperature(manorTemp: 37.5,)),
        ],
      ),
    );
  }

  Widget _makeSliderImage() {
    return Container(
      height: size.width * 0.8,
      child: Stack(
        children: [
          Hero(
            tag: widget.data["cid"],
            child: CarouselSlider(
              options: CarouselOptions(
                  height: size.width * 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList.map((i) {
                return Container(
                  width: size.width,
                  height: size.width,
                  color: Colors.red,
                  child: Image.asset(
                    widget.data["image"],
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imgList.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      height: 55,
      width: size.width,
      color: Colors.red,
    );
  }
}
