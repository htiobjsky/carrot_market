import 'package:carrot_market/page/detail.dart';
import 'package:carrot_market/repository/contents_repository.dart';
import 'package:carrot_market/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyFavoriteContents extends StatefulWidget {
  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentsRepository contentsRepository;
  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        future: _loadMyFavoriteContentsList(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasError) {
            return Center(child: Text("데이터 오류 입니다!!"),);
          }
          if(snapshot.hasData)  {
            return _makeDataList(snapshot.data);
          }
          return Center(child: Text("해당 지역의 데이터가 없습니다 !!"),);
        }
    );
  }

  Future<List<dynamic>> _loadMyFavoriteContentsList() async{
    return await contentsRepository.loadFavoriteContents();
  }

  _makeDataList(List<dynamic> datas){
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return DetailContentView(data: datas[index],);
            }));
            print(datas[index]["title"]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Hero(
                    tag: datas[index]["cid"],
                    child: Image.asset(
                      datas[index]['image'],
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  child: Expanded(
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas[index]["title"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            datas[index]["location"],
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black.withOpacity(
                                  0.3,
                                )),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            DataUtils.calcStringToWon(datas[index]["price"]),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/heart_off.svg",
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(datas[index]["likes"]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Color(0xffbbbbbb), //Colors.black.withOpacity(0.4)
        );
      },
      itemCount: datas.length,
    );
  }

  Widget _appbarWidget() {
    return AppBar(
      title: Text("관심목록", style: TextStyle(fontSize: 15),),
    );
  }
}
