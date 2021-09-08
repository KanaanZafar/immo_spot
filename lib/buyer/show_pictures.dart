import 'package:after_init/after_init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowPictures extends StatefulWidget {
  Widget reqAppBar;
  List picturesList;
  int currentPicNum;

  ShowPictures(this.reqAppBar, this.picturesList, this.currentPicNum);

  @override
  _ShowPicturesState createState() =>
      _ShowPicturesState(reqAppBar, picturesList, currentPicNum);
}

class _ShowPicturesState extends State<ShowPictures>
    with AfterInitMixin<ShowPictures> {
  Widget reqAppBar;
  List picturesList;
  int currentPicNum;

  _ShowPicturesState(this.reqAppBar, this.picturesList, this.currentPicNum);

  double totalHeight;
  double totalWidth;
  double miniWidth;
  double miniHeight;

  void didInitState() {
    // No need to call super.didInitState().
    // setState() is not required because build() will automatically be called by Flutter.
//    size = MediaQuery.of(context).size;
    miniHeight = MediaQuery.of(context).size.height / 10.5;
    miniWidth = MediaQuery.of(context).size.height / 10.5;
    totalWidth = MediaQuery.of(context).size.width;
    totalHeight = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 50;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            child: reqAppBar, preferredSize: Size.fromHeight(87.5)),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              picsRow(),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
//                curve: Curves.bounceIn,
                width: totalWidth,
                height: totalHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(
                      image: NetworkImage(
                        picturesList[currentPicNum],
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              /* Container(
                width: totalWidth,
                height: totalHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(
                      image: NetworkImage(
                        picturesList[currentPicNum],
                      ),
                      fit: BoxFit.cover),
                ),
              ), */
              Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget picsRow() {
    List<Widget> tmp =
        List<Widget>.generate(picturesList.length, (index) => reqpic(index));
//   print('tmp: ${tmp.length}');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tmp,
      ),
    );
  }

  Widget reqpic(int picNum) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          totalHeight = 1.0;
          totalWidth = 1.0;
          miniHeight = 1.0;
        });
        currentPicNum = picNum;
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          miniHeight = MediaQuery.of(context).size.height / 10.5;
          totalWidth = MediaQuery.of(context).size.width;
          totalHeight = MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width / 50;
        });
      },
     /*& child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: picNum == currentPicNum ? miniHeight:MediaQuery.of(context).size.height/10.5,
        width: picNum == currentPicNum ? miniHeight:MediaQuery.of(context).size.height/10.5,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 50),

        decoration: picNum == currentPicNum
            ? BoxDecoration(color: Colors.transparent)
            : BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      picturesList[picNum],
                    ),
                    fit: BoxFit.cover),
              ),
      ), */
child: Container(

        height: MediaQuery.of(context).size.height / 10.5,
        width: MediaQuery.of(context).size.height / 10.5,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 50),
        decoration: picNum == currentPicNum
            ? BoxDecoration(color: Colors.transparent)
            : BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      picturesList[picNum],
                    ),
                    fit: BoxFit.cover),
              ),
      ),
    );
  }
}
