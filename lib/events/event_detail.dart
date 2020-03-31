import 'package:flutter/material.dart';

class EventsDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildEventsDetail();
  }

  Widget _buildEventsDetail() {
    const googleMapsApiKey = "AIzaSyDzk_I2gA5qgUvVTHNZs_vCpkqQJCMF5Es";
    const loremIpsum =
        'Vivamus semper ornare metus, in malesuada quam suscipit at. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas non neque eget mi ultricies commodo lacinia id felis. Donec ante orci, imperdiet eu velit quis, pharetra volutpat leo. Sed vel velit facilisis diam convallis auctor. Sed maximus risus at quam vehicula, in imperdiet arcu commodo. Vestibulum egestas pretium quam, vel pellentesque diam pharetra a. Nulla eget arcu tempor augue dapibus lobortis. Nam a lacinia elit. Phasellus vitae quam dapibus, ornare urna ut, congue diam. Sed sed risus nulla. Maecenas facilisis, massa in porta posuere, turpis mauris dignissim ante, vitae lobortis ligula sem eu tellus. Integer commodo purus eget nulla sollicitudin, ac aliquet lectus egestas. Nulla ut lectus ullamcorper, iaculis turpis semper, consectetur ex. In gravida velit vitae risus scelerisque, sed placerat turpis iaculis. Pellentesque et felis ac risus interdum scelerisque at at lacus.';
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("20 Mission Bar & Restaurant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                      child: Expanded(
                        flex: 2,
                        child: Padding(
                          child: Image.network(
                            'https://maps.googleapis.com/maps/api/staticmap?center=6.2170401,-75.5770741&zoom=15&size=600x400&$googleMapsApiKey',
                          ),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      onTap: () => {
                        //TODO OPEN MAPS APP
                      }),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sample',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Sample',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Sample',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    flex: 1,
                  )
                ],
              ),
              Text(loremIpsum),
              Text(
                'Cervezas:',
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
