import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LinkageRollingPage(),
    );
  }
}

//修改这里的数据会更改一页高度
const double leftItemHeight = 45; // 左边一个item的高度
const double rightItemTitleHeight = 38; // 右边一个标题的高度
const int leftWidgetFlex = 3; // 左边组件占据空间的比例
const int rightWidgetFlex = 9; // 右边组件占据空间的比例
const int rightGridViewCrossAxisCount = 3; //右侧GirdView一排数量，这里测试时为3


class LinkageRollingPage extends StatefulWidget {
  final arguments;
  const LinkageRollingPage({Key? key, this.arguments}) : super(key: key);

  @override
  _LinkageRollingPageState createState() => _LinkageRollingPageState();
}

class _LinkageRollingPageState extends State<LinkageRollingPage> {

  final ScrollController _leftListController = ScrollController(initialScrollOffset: 0);
  final ScrollController _rightListController = ScrollController(initialScrollOffset: 0);

  //这里给右侧List中的Grid一个初始化高度，会在_calculation（）实时计算，这里可以是任何正值
  double _rightGridItemHight = 20;


  //左侧列表测试用例，后续使用可以自定义任何List
  final List _left = const [
    '测试用例1',
    '测试用例2',
    '测试用例3',
    '测试用例4',
    '测试用例5',
    '测试用例6',
    '测试用例7',
    '测试用例8',
    '测试用例9',
    '测试用例10',
  ];

  //右侧GridView中的项目数量，后续使用可以使用项目中的list数量，这里仅作为测试
  final List ll =[1,2,3,4,5,6,7,8,9,15];


  //这个数组是用来计算，右侧每一页要跳转到标题的高度，属于累加
  final List _rightOffSetStepList = [];

  //这里是对于最后一个项目后填入空白空间来保证右侧ListView可以被滑动到顶部，会在_calculation（）方法中计算实际高度
  double _lastGridHeight = 0.0;

  int _indexLeft = 0;



  @override
  void initState() {
    super.initState();

    //左侧Listview的监听，目前没有用到
    _leftListController.addListener((){

    });


    //右侧ListView的监听
    _rightListController.addListener((){

      //滚动超过右侧Listview的项目长度时，将左侧选中最后一项，这一个判断不添加的话，左侧ListView选择不到最后一项
      if(_rightOffSetStepList.last <= _rightListController.offset){
        setState(() {
          _indexLeft =  _rightOffSetStepList.length -1;
        });
      }else{
        for(int i = 0; i < _rightOffSetStepList.length ; i++){
          if(_rightOffSetStepList[i] > _rightListController.offset + 0.1){
            setState(() {
              _indexLeft =  (i - 1 < 0 ? 0 : ( i - 1) );
            });
            break;
          }
        }
      }
    });
  }

  //计算右侧的一页高度
  // void _calculation(){
  //   //这个数组用来计算单独一个List的页面高度
  //   List rightListStep = [];
  //   _rightOffSetStepList.clear();
  //
  //
  //   _rightGridItemHight = (MediaQuery.of(context).size.width - 20) * rightWidgetFlex / (leftWidgetFlex + rightWidgetFlex) / rightGridViewCrossAxisCount ;
  //   rightListStep.add((_rightGridItemHight * ( (ll[0] ~/ rightGridViewCrossAxisCount) + (ll[0] % rightGridViewCrossAxisCount == 0 ? 0 : 1)) + rightItemTitleHeight));
  //   for(int i =1; i<_left.length ; i++){
  //     rightListStep.add((_rightGridItemHight * ( (ll[i] ~/ rightGridViewCrossAxisCount) + (ll[i] % rightGridViewCrossAxisCount == 0 ? 0 : 1)) + rightItemTitleHeight));
  //   }
  //
  //   _lastGridHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kBottomNavigationBarHeight) - rightListStep.last;
  //   if(_lastGridHeight < 0){
  //     _lastGridHeight = 20; //避免负数造成报错，这个固定值可以随项目需要改
  //   }
  //
  //   for(int i =0;i< rightListStep.length  ; i++){
  //     double off = 0.0;
  //     for(int j = 0; j < i ; j++){
  //       off += rightListStep[j];
  //     }
  //     _rightOffSetStepList.add(off);
  //   }
  // }

  //计算右侧的一页高度 - ListView版本
  void _calculation(){
    //这个数组用来计算单独一个List的页面高度
    List rightListStep = [];
    _rightOffSetStepList.clear();


    _rightGridItemHight = 50; // 这里设置一个ListView项目的高度
    rightListStep.add((_rightGridItemHight * ( (ll[0]) + (ll[0] % 1 == 0 ? 0 : 1)) + rightItemTitleHeight));
    for(int i =1; i<_left.length ; i++){
      rightListStep.add((_rightGridItemHight * ( (ll[i]) + (ll[i] % 1 == 0 ? 0 : 1)) + rightItemTitleHeight));
    }

    _lastGridHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kBottomNavigationBarHeight) - rightListStep.last;
    if(_lastGridHeight < 0){
      _lastGridHeight = 20; //避免负数造成报错，这个固定值可以随项目需要改
    }

    for(int i =0;i< rightListStep.length  ; i++){
      double off = 0.0;
      for(int j = 0; j < i ; j++){
        off += rightListStep[j];
      }
      _rightOffSetStepList.add(off);
    }
  }

  @override
  void dispose() {
    _leftListController.dispose();
    _rightListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculation();
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter联动列表"),
        ),
        body:Row(
          children: [
            Expanded(
              flex: leftWidgetFlex,
              child: _left_listViewWidget(),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: rightWidgetFlex,
              child: _right_listViewWidget(),
            ),
            const SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }

  //左侧分类栏
  Widget _left_listViewWidget(){
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 30),
      color: Colors.white,
      child: ListView.builder(
        controller: _leftListController,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              _rightListController.animateTo(_rightOffSetStepList[index], duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: leftItemHeight,
              padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
              color: _indexLeft == index ? Colors.red : const Color.fromRGBO(249, 249, 249, 1),
              alignment: Alignment.center,
              child:  Text(_left[index].toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
            ),
          );
        },
        itemCount: _left.length,
      ),
    );
  }

  //右侧项目栏 - GridView版本
  // Widget _right_listViewWidget(){
  //   return Container(
  //       alignment: Alignment.topCenter,
  //       margin: const EdgeInsets.fromLTRB(0, 8, 0, 30.0),
  //       color: Colors.white,
  //       child : ListView.builder(
  //         itemBuilder: (context,index){
  //           if(_left.length > index +1 ){
  //             return Column(
  //               children: [
  //                 Container(
  //                   color: Colors.red,
  //                   height: rightItemTitleHeight,
  //                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                   child: Row(
  //                     children: [
  //                       const Expanded(
  //                         child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
  //                       ),
  //                       Container(
  //                         child: Text(_left[index],style: const TextStyle(fontSize: 13,color: Color.fromRGBO(51, 51, 51, 1)),),
  //                         padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
  //                       ),
  //                       const Expanded(
  //                         child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 GridView.builder(
  //                   padding: const EdgeInsets.all(0),
  //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: rightGridViewCrossAxisCount, //每行三列
  //                     childAspectRatio: 1, //显示区域宽高相等
  //                   ),
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   shrinkWrap: true,
  //                   itemCount: ll[index],
  //                   itemBuilder: (context, index) {
  //                     return GestureDetector(
  //                       child: Container(
  //                         height: _rightGridItemHight,
  //                         color: Colors.blue,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Container(
  //                               child:const Icon(Icons.print),
  //                               padding:const EdgeInsets.fromLTRB(0, 0, 0, 10),
  //                             ),
  //                             Text("测试" + index.toString()),
  //                           ],
  //                         ),
  //                         padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
  //                         margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       ),
  //                       behavior: HitTestBehavior.opaque,
  //                       onTap: (){
  //
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ],
  //             );
  //           }else{
  //
  //             //最后一项特别处理，需要使用SizedBox
  //             return Column(
  //               children: [
  //                 Container(
  //                   color: Colors.red,
  //                   height: rightItemTitleHeight,
  //                   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                   child: Row(
  //                     children: [
  //                       const Expanded(
  //                         child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
  //                       ),
  //                       Container(
  //                         child: Text(_left[index],style: const TextStyle(fontSize: 13,color: Color.fromRGBO(51, 51, 51, 1)),),
  //                         padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
  //                       ),
  //                       const Expanded(
  //                         child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 GridView.builder(
  //                   padding: const EdgeInsets.all(0),
  //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 3, //每行三列
  //                     childAspectRatio: 1, //显示区域宽高相等
  //                   ),
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   shrinkWrap: true,
  //                   itemCount: ll[index],
  //                   itemBuilder: (context, index) {
  //                     return GestureDetector(
  //                       child: Container(
  //                         height: _rightGridItemHight,
  //                         color: Colors.amber,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Container(
  //                               child:const Icon(Icons.print),
  //                               padding:const EdgeInsets.fromLTRB(0, 0, 0, 10),
  //                             ),
  //                             Text("测试" + index.toString()),
  //                           ],
  //                         ),
  //                         padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
  //                         margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       ),
  //                       behavior: HitTestBehavior.opaque,
  //                       onTap: (){
  //
  //                       },
  //                     );
  //                   },
  //                 ),
  //                 SizedBox(height: _lastGridHeight,),
  //               ],
  //             );
  //           }
  //         },
  //         itemCount: _left.length,
  //         controller: _rightListController,
  //       )
  //   );
  // }

  //右侧项目栏 - ListView 版本
  Widget _right_listViewWidget(){
    return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 30.0),
        color: Colors.white,
        child : ListView.builder(
          itemBuilder: (context,index){
            if(_left.length > index +1 ){
              return Column(
                children: [
                  Container(
                    color: Colors.red,
                    height: rightItemTitleHeight,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                          child: Text(_left[index],style: const TextStyle(fontSize: 13,color: Color.fromRGBO(51, 51, 51, 1)),),
                        ),
                        const Expanded(
                          child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ll[index],
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){

                        },
                        child: Container(
                          height: _rightGridItemHight,
                          color: Colors.blue,
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Container(
                              //   padding:const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              //   child:const Icon(Icons.print),
                              // ),
                              Text("测试$index"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }else{

              //最后一项特别处理，需要使用SizedBox
              return Column(
                children: [
                  Container(
                    color: Colors.red,
                    height: rightItemTitleHeight,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                          child: Text(_left[index],style: const TextStyle(fontSize: 13,color: Color.fromRGBO(51, 51, 51, 1)),),
                        ),
                        const Expanded(
                          child: Divider(color: Color.fromRGBO(216, 216, 216, 1),height: 1,),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ll[index],
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){

                        },
                        child: Container(
                          height: _rightGridItemHight,
                          color: Colors.amber,
                          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("测试$index"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: _lastGridHeight,),
                ],
              );
            }
          },
          itemCount: _left.length,
          controller: _rightListController,
        ),
    );
  }
}
