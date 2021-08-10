import 'package:bnotes/constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: kGlobalOuterPadding,
            child: Column(
              children: [
                Padding(
                  padding: kGlobalOuterPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/bnotes-transparent.png',
                        height: 100,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Text(
                            kAppName,
                            style: TextStyle(fontFamily: 'Raleway', fontSize: 24.0),
                          )),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Nandan Menon (nahnah)'),
                  subtitle: Text('Lead Dev & app design'),
                ),
                ListTile(
                  title: Text('Rajesh Menon (suranjum)'),
                  subtitle: Text('Lead Dev'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
