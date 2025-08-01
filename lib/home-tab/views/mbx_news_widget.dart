import 'package:mbankingbackoffice/news/models/mbx_news_model.dart';

import '../../widget-x/all_widgets.dart';

// ignore: must_be_immutable
class MbxNewsWidget extends StatelessWidget {
  final MbxNewsModel news;
  const MbxNewsWidget(this.news, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: InkWellX(
        highlightColor: ColorX.theme.withValues(alpha: 0.1),
        cornerRadius: 12.0,
        clicked: () {
          Get.toNamed('/news', arguments: news);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageX(
              url: news.image,
              width: double.infinity,
              height: 100.0,
              cornerRadius: 12.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 4.0),
            TextX(
              news.title,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: ColorX.gray,
              textAlign: TextAlign.start,
              maxLines: 3,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
