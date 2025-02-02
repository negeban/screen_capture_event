import 'dart:io';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';
import 'package:grab_hashtag/common/ad/banner_ad_widget.dart';
import 'package:grab_hashtag/common/ad/interstitial_ad_widget.dart';
import 'package:grab_hashtag/common/detector/hashtag_detector.dart';
import 'package:grab_hashtag/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:grab_hashtag/common/payment/payment_service.dart';
import 'package:grab_hashtag/common/util/file_utils.dart';
import 'package:grab_hashtag/model/hashtag.dart';
import 'package:grab_hashtag/repositories/hashtag_repository.dart';
import 'package:grab_hashtag/ui/components/editable_hashtag_component.dart';
import 'package:grab_hashtag/widgets/appbar/custom_app_bar.dart';
import 'package:grab_hashtag/widgets/center_indicator.dart';

class EditHashTagPage extends StatefulWidget {
  final int hashTagId;
  const EditHashTagPage({Key? key, required this.hashTagId}) : super(key: key);

  @override
  _EditHashTagPageState createState() => _EditHashTagPageState();
}

class _EditHashTagPageState extends LifecycleWatcherState<EditHashTagPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(hasActions: false, fromOnBoardingPage: false, title: 'Edit hash tags'),
      body: Center(
        child: Column(
          children: getWidgets()
        )
      )
    );
  }

  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 10,));

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
      widgets.add(const SizedBox(height: 10,));
      widgets.add(const SizedBox(height: 10,));

    }
    widgets.add(
      FutureBuilder<HashTag>(
          future: _findHashTag(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CenterIndicator();
            }
            return snapshot.data == null ? buildEmptyResult() : buildResult(snapshot);
          }
      )
    );
    return widgets;
  }

  Widget buildResult(AsyncSnapshot<HashTag> snapshot) {
    return Expanded(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return EditableHashTagComponent(hashTag: snapshot.data!);
            }
        )
    );
  }

  Widget buildEmptyResult() {
    return Container(
      alignment: Alignment.center,
      child: EmptyWidget(
        image: null,
        packageImage: PackageImage.Image_1,
        title: 'No hash tag',
        titleTextStyle: const TextStyle(
          fontSize: 22,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xffabb8d6),
        ),
      )
    );
  }

  Future<HashTag> _findHashTag() async {
    HashTagEntity hashTagEntity = await HashTagRepository.getHashTag(widget.hashTagId);
    return HashTag.buildFrom(hashTagEntity);
  }
}