import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market/components/manor_temperature_widget.dart';
import 'package:carrot_market/repository/contents_repository.dart';
import 'package:carrot_market/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView({Key key, this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  ContentsRepository contentsRepository;
  Size size;
  List<String> imgList;
  int _current;
  double scrollPositionToAlpah = 0;
  ScrollController _controller = ScrollController();
  AnimationController _animationController;
  Animation _colorTween;
  bool isMyFavoriteContent;
  //final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255)
          scrollPositionToAlpah = 255;
        else
          scrollPositionToAlpah = _controller.offset;

        _animationController.value = scrollPositionToAlpah / 255;
      });
    });
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);
    isMyFavoriteContent = false;
    contentsRepository = ContentsRepository();
    _loadMyFavoriteContentState();
  }
  _loadMyFavoriteContentState () async {
    bool tf = await contentsRepository.isMyFavoriteContents(widget.data["cid"]);
    setState(() {
      isMyFavoriteContent = tf;
    });

  }

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
      //key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) {
          return Icon(icon, color: _colorTween.value);
        });
  }

  Widget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAlpah.toInt()),
      elevation: 0,
      leading: IconButton(
          icon: _makeIcon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        IconButton(
            icon: _makeIcon(Icons.share),
            onPressed: () {}),
        IconButton(
            icon: _makeIcon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "디지털/가전 ∙ 22시간 전",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3 ∙ 관심 17 ∙ 조회 295",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "모두 보기",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(controller: _controller, slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          delegate: SliverChildListDelegate(List.generate(20, (index) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    child: Container(
                      color: Colors.grey,
                      height: 120,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Text(
                    "상품 제목",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "금액",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList()),
        ),
      )
    ]);
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
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BJSKY",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("서울시 반포동"),
            ],
          ),
          Expanded(
              child: ManorTemperature(
            manorTemp: 37.5,
          )),
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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 55,
        width: size.width,
        child: Row(
          children: [
            GestureDetector(
                onTap: () async {
                  if(isMyFavoriteContent) {
                    //제거
                    await contentsRepository.deleteMyFavoriteContent(widget.data["cid"]);
                  } else {
                    await contentsRepository.addMyFavoriteContent(widget.data);
                  }
                  setState(() {
                    isMyFavoriteContent = !isMyFavoriteContent;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isMyFavoriteContent ? "관심목록에 추가되었습니다" :  "관심목록에서 제거되었습니다"),
                      duration: Duration(milliseconds: 1000),)
                  );
                },
                child: SvgPicture.asset(
                  isMyFavoriteContent ? "assets/svg/heart_on.svg" :  "assets/svg/heart_off.svg" ,
                  width: 25,
                  height: 25,
                  color: Color(0xfff08f4f),
                )),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 10),
              width: 1,
              height: 40,
              color: Colors.grey.withOpacity(0.3),
            ),
            Column(
              children: [
                Text(
                  DataUtils.calcStringToWon(widget.data["price"]),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  "가격 제안 불가",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff08f4f),
                      borderRadius: BorderRadius.circular(
                        5,
                      )),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
