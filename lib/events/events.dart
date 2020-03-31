import 'package:flutter/material.dart';

class Events extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EventsState();
  }
}


class EventsState extends State<Events>{
  List<int> items = List.generate(10, (i) => i);
  ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
    void initState() {
      super.initState();
      _scrollController.addListener((){
        if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
          _getMoreData();
        }
      });
    }
  
  @override
    void dispose() {
      super.dispose();
      _scrollController.dispose();
    }

  _getMoreData() async {
      if (!isPerformingRequest) {
        setState(() => isPerformingRequest = true);
        List<int> newEntries = await fakeRequest(items.length, items.length + 10);
        if(newEntries.isEmpty){
          double edge = 50.0;
          double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
          if(offsetFromBottom < edge){
            _scrollController.animateTo(
              _scrollController.offset - (edge -offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut
            );
          }
        }
        setState(() {
          items.addAll(newEntries);
          isPerformingRequest = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return _infinityList();
  }

  Widget _infinityList(){
    return Container(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          if(index == items.length-1){
            return _buildProgressIndicator();
          }else{
            return ListTile(title: Text("Number $index"));
          }
        },
        controller: _scrollController,
      ),
    );
  }

  Future<List<int>> fakeRequest(int from, int to) async{
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(to - from, (i) => i + from);
    });
  }

  Widget _buildProgressIndicator(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
        )
      )
    );
  }
}