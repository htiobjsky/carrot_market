import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;

  const DetailContentView({Key key, this.data}) : super(key: key);
  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  Size size;
  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbarWidget(),
        body: _bodyWidget(),
      );
    }

    Widget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(icon: Icon(Icons.share), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
    }

    Widget _bodyWidget() {
    return Container(
      child: Hero(
          tag: widget.data['cid'],
          child: Image.asset(widget.data['image'], fit: BoxFit.fill, width: size.width,)),
    );
    }
}
