
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/transactions/order_row.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';
import 'package:jozapp_flutter/models/types.dart';

class TransactionsScreen extends StatefulWidget {
  final VoidCallback? gotoHome;
  const TransactionsScreen({Key? key, this.gotoHome}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  Widget _loadMore(int len) {
    var model = Provider.of<AppDataModel>(context, listen: false);
    int limit = (int.tryParse(getStringField(model.transHist, C.limit)) ?? 0);

    var dataLen = model.hist.length;

    if(limit > dataLen+AppConfig.ordersCount) return Container(height: 30,);

    if(len == 0) {
      return const NoContent(
        title: "No Transactions",
        subtitle: "You have not started any transaction yet",
      );
    }

    return ListTile(
      onTap: () async {
        model.setTransHist(C.limit, (limit + AppConfig.ordersCount).toString());
        RestApi.loadHist();
      },
      title: model.loading
          ? const LinearProgressIndicator()
          : Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: AppStyles.boxShadow,
                borderRadius: AppStyles.borderAll(),
                color: Colors.black
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("txt.load_more".T(), style: AppStyles.whiteText,),
                ],
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);
    var data = model.hist;

    int len = data.length;
    return Scaffold(
      body: Container(
        color: AppColors.black,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(onPressed: widget.gotoHome, icon: const BackButtonIcon(),), // ,
              backgroundColor: AppColors.accent,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('main.trans'.T()),
                // background: WalletLogo(width: 3,),
              ),
            ),

            const SliverDelim(
              fromTop: true,
              negative: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return index == len ? _loadMore(len) :  OrderRow(
                      order: data[index], last: index == len - 1,
                  );
                },
                childCount: len+1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
