import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:fyp_lms/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/dashboard/dashboard_controller.dart';
import 'package:fyp_lms/ui/dashboard/upcoming_event_widget.dart';
import 'package:fyp_lms/ui/dashboard/post_item.dart';

import '../../web_service/model/user/account.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController controller = DashboardController();
  SharedPreferences? _sPref;

  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      _sPref = value;
      initializeData();
    });

  }

  initializeData() {
    controller.accountId = _sPref!.getString('account');
    controller.accountName = _sPref!.getString('username');
    controller.user = Account.fromJson(jsonDecode(_sPref!.getString('accountInfo')!));
    controller.accountType = _sPref!.getInt('accountType');

    controller.initRefresh(context, () {
      setState(() {});
    }).then((value) {
      setState(() {
        controller.isLoading = false;
      });
    });

  }

  fetchPosts() async {
    await controller.fetchPost(context, () {
      setState(() {});
    }).then((result) {
      setState(() {
        controller.isLoading = false;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: RefreshIndicator(
        displacement: 60,
        onRefresh: () => controller.initRefresh(context, () {
          setState(() {});
        }),
        child: CustomScrollView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            //PROFILE ICON
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: x_large_padding, bottom: x_large_padding, right: large_padding, left: x_large_padding),
                        child: RichText(
                          text: TextSpan(
                            text: 'WELCOME,   ',
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: TITLE,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: controller.accountName ?? 'Undefined',
                                style: GoogleFonts.poppins().copyWith(
                                  fontSize: BIG_TITLE,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1,
                                  color: Colors.black,
                                ),
                              )
                            ]
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(top: x_large_padding, bottom: x_large_padding, right: large_padding),
                    //   padding: const EdgeInsets.all(normal_padding),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //   ),
                    //   child: Icon(Icons.person, color: BG_COLOR_4, size: 22,).onTap(() {
                    //
                    //   }),
                    // ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: x_large_padding, bottom: large_padding, left: large_padding),
                child: Text('Upcoming Event', style: GoogleFonts.poppins().copyWith(
                  fontSize: TITLE,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),

            //UPCOMING COURSE
            SliverToBoxAdapter(
              child: controller.isLoading ? Center(child: CircularProgressIndicator(color: BG_COLOR_4,),) : controller.upcomingCourseList.isEmpty ? const SizedBox() : CarouselSlider.builder(
                itemCount: controller.upcomingCourseList.length,
                itemBuilder: (BuildContext ctx, int index, int pageIndex) {
                  return upcomingEventWidget(context, controller, controller.upcomingCourseList[index], controller.upcomingDateList[index]);
                },
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  disableCenter: true,
                  viewportFraction: 0.9,
                ),
              )
            ),


            //POST LISTING
            SliverPadding(
              padding: const EdgeInsets.only(top: x_large_padding, bottom: large_padding, left: large_padding, right: large_padding),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Post', style: GoogleFonts.poppins().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: TITLE,
                    ),),

                    Container(
                      padding: const EdgeInsets.only(left: large_padding, right: large_padding, top: small_padding, bottom: small_padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: BG_COLOR_4.withOpacity(0.2),
                      ),
                      child: Icon(Icons.add, size: 18,),
                    ).onTap(() {
                      Navigator.of(context).pushNamed('/AddPostScreen', arguments: {}).then((value) {
                        controller.initRefresh(context, () {
                          setState(() {});
                        });
                      });
                    })
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: controller.isLoading ? Center(child: CircularProgressIndicator(color: BG_COLOR_4,),) : ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: controller.postList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return postItem(context, controller.postList[index], controller, () {
                    setState(() {});
                  }, controller.postLikes[controller.postList[index].id]!).onTap(() {
                    //ENTER POST DETAIL PAGE
                    Navigator.of(context).pushNamed('/PostDetailScreen', arguments: {
                      'post': controller.postList[index],
                      'isLiked': controller.postLikes[controller.postList[index].id],
                    }).then((value) {
                      controller.initRefresh(context, () { });
                    });
                  });
                },
                padding: const EdgeInsets.only(bottom: x_large_padding),
              ),
            )


          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
