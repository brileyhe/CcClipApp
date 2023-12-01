import 'package:flutter/material.dart';
import 'package:cc_clip_app/pages/PageContainer.dart';

// 侧边栏小组件
class DrawMenu extends StatefulWidget {
  const DrawMenu({
    super.key,
    this.pageName,
    this.drawerWidth = 250,
    this.onDrawerCall,
    this.pageView,
    this.drawerIsOpen,
    this.animatedIconData = AnimatedIcons.arrow_menu,
  });

  final PageName? pageName;
  final double drawerWidth;
  final Function(PageName)? onDrawerCall;
  final Widget? pageView;
  final Function(bool)? drawerIsOpen;
  final AnimatedIconData? animatedIconData;


  @override
  DrawMenuState createState() => DrawMenuState();
}

class DrawMenuState extends State<DrawMenu> with TickerProviderStateMixin {
  ScrollController? scrollController;
  AnimationController? iconAnimationController;
  AnimationController? animationController;

  double scrollOffset = 0.0;// 标识抽屉是否打开

  @override
  void initState() {
    // 动画
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    // icon 动画
    iconAnimationController = AnimationController(duration: const Duration(milliseconds: 0), vsync: this);
    iconAnimationController?.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    // 滑动控制
    scrollController = ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController!.addListener(() {
      final double offset = scrollController!.offset;
      // 打开侧边栏
      if (offset <= 0) {
        if (scrollOffset != 1.0) {
          setState(() {
            scrollOffset = 1.0;
            try {
              widget.drawerIsOpen!(true);
            } catch (_) {}
          });
        }
        // 设置按钮样式
        iconAnimationController?.animateTo(0.0,
            duration: const Duration(milliseconds: 0),
            curve: Curves.fastOutSlowIn);
      }else if(offset > 0 && offset < widget.drawerWidth.floor()) {
        // 设置按钮样式
        iconAnimationController?.animateTo(
            (offset * 100 / (widget.drawerWidth)) / 100,
            duration: const Duration(milliseconds: 0),
            curve: Curves.fastOutSlowIn);
      } else {
        // 关闭侧边栏
        if (scrollOffset != 0.0) {
          setState(() {
            scrollOffset = 0.0;
            try {
              widget.drawerIsOpen!(false);
            } catch (_) {}
          });
        }
        iconAnimationController?.animateTo(1.0,
            duration: const Duration(milliseconds: 0),
            curve: Curves.fastOutSlowIn);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => getInitState());
    super.initState();
  }

  // 帧渲染回调，类比requestAnimationFrame
  Future<bool> getInitState() async {
    scrollController?.jumpTo(
      widget.drawerWidth,
    );
    return true;
  }

  void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (scrollController!.offset != 0.0) {
      scrollController?.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController?.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width + widget.drawerWidth,
          child: Row(
            children: <Widget>[
              SizedBox( // 抽屉
                width: widget.drawerWidth,
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: iconAnimationController!,
                  builder: (BuildContext context, Widget? child) {
                    return Transform(
                        transform: Matrix4.translationValues(scrollController!.offset, 0.0, 0.0),
                        child: Text('123')
                    );
                  },
                ),
              ),
              SizedBox( // 主屏幕
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(// 背景
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          blurRadius: 24),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      // 抽屉打开的情况下屏蔽主屏幕的事件
                      IgnorePointer(
                        ignoring: scrollOffset == 1 || false,
                        child: widget.pageView,
                      ),
                      // 抽屉打开时，点击主屏幕关闭抽屉
                      if (scrollOffset == 1.0)
                        InkWell(
                          onTap: () {
                            onDrawerClick();
                          },
                        ),
                      // 菜单按钮动画
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 4, left: 4),
                        child: SizedBox(
                          width: AppBar().preferredSize.height - 18,
                          height: AppBar().preferredSize.height - 18,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                              child: Center(
                                child: AnimatedIcon(
                                    color: Colors.white,
                                    icon: widget.animatedIconData ?? AnimatedIcons.arrow_menu,
                                    size: 28,
                                    progress: iconAnimationController!
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                onDrawerClick();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}