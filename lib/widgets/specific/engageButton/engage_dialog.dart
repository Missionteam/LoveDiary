import 'package:flutter/material.dart';

import '../../image_buttom.dart';

class EngageDialog extends StatelessWidget {
  const EngageDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 190, left: 20, right: 20, top: 140),
        child: Container(
          color: Colors.white,
          // width: 300,
          // height: 400,
          // padding: EdgeInsets.only(bottom: 50.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 50),
            children: [
              MaterialButton(
                  elevation: 8.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/GiveStamp.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    // showDialog(
                    //     context: context,
                    //     builder: (_) {
                    //       return EngageStamps();
                    //     });
                  }),
              Container(
                color: Colors.yellow,
                height: 50,
                alignment: Alignment.center,
                child: Text('彼氏'),
              ),
              Container(
                color: Colors.yellow,
                height: 50,
                alignment: Alignment.center,
                child: Text('彼氏'),
              ),
              Container(
                color: Colors.yellow,
                height: 50,
                alignment: Alignment.center,
                child: Text('彼氏'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EngageStamps extends StatelessWidget {
  const EngageStamps({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 190, left: 20, right: 20, top: 140),
        child: Container(
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 50),
            children: [
              StampButton(imageName: 'Stamp1.png'),
              StampButton(imageName: 'Stamp2.png'),
              StampButton(imageName: 'Stamp3.png'),
              StampButton(imageName: 'Stamp4.png'),
              StampButton(imageName: 'NoStamp.png')
            ],
          ),
        ),
      ),
    );
  }
}
