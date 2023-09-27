import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/intl/langs/fa.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:dotted_border/dotted_border.dart';

import 'booking_detail.dart';

RoundIcon _bullet = RoundIcon(Icons.lens, size: 8, color: AppColors.grey1, foregroundColor: Colors.grey[600]!,);

class TicketRow extends StatelessWidget {
  final bool last;
  final int index;
  final bool isDetail;
  final bool hasDate;
  final SearchResult result;
  const TicketRow({Key? key, required this.result, this.last = false, this.isDetail = false, this.index = -1, this.hasDate = false}) : super(key: key);

  void onTap() async {
    TicketModel.i.selectedResult = result;
    Get.to(() => const BookingDetail(),
        opaque: true,
        transition: Transition.fadeIn
    );
  }

  Widget get addresses {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.origin, style: AppStyles.accentText16B,),
            Text("( ${result.originLocation} )", style: AppStyles.accentText,),
          ],
        ),

        Image.network(AticketApi.getAirlineLogoUrl(result.airlineCode),
          width: 40, height: 40,
          // loadingBuilder: (_, e, __) => const SizedBox(
          //   width: 40, height: 40,
          //   child: CircularProgressIndicator(),
          // ),
          errorBuilder: (_, e, __) => const Icon(Icons.error, size: 40, color: AppColors.accent,),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(result.destination, style: AppStyles.accentText16B,),
            Text("(${result.destinationLocation})", style: AppStyles.accentText,),
          ],
        ),
      ],
    );
  }

  Widget get bullets {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _bullet,
        Expanded(child: DottedBorder(
          padding: EdgeInsets.zero,
          color: AppColors.grey2,
          dashPattern: const [4, 4],
          strokeWidth: 1,
          child: const SizedBox(
            height: 0,
            width: double.infinity,
            // color: Colors.red,
          ),
        ),),
        _bullet,
      ],
    );
  }

  Widget get priceRow {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(result.totalPrice.toTwoDigit(false) + result.currency, style: AppStyles.accentText16B,),
              const Text("  Ticket Price", style: AppStyles.greyText,),
            ],
          ),
          GestureDetector(
              onTap: () {
                showInfo("Under construction");
              },
              child: const Text("View details", style: AppStyles.accentText,)),
        ],
      ),
    );
  }

  Widget get timesWidget {
    return PadV(
      padding: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PadV(child: Text("Depart", style: AppStyles.grayText16,)),
              Text(result.departureTime, style: AppStyles.darkText14B,),
            ],
          ),

          Text(result.duration, style: AppStyles.greyText,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const PadV(child: Text("Flight Number", style: AppStyles.grayText16,)),
              Text(result.flightNumber, style: AppStyles.darkText14B,),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => hasDate ? Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Text(result.departureDate, style: AppStyles.whiteTextB,),
      ),
      bodyDetail,
    ],
  ) : bodyDetail;

  Widget get bodyDetail => isDetail || hasDate ? body : GestureDetector(
    child: body,
    onTap: onTap,
  );

  Widget get body => Hero(
      tag: "SearchResult$index",
      child: Padding(
        padding: EdgeInsets.only(
            left: 12, right: 12,
            top: 4,
            bottom: last ? 20 : 4
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                addresses,
                timesWidget,
                bullets,
                priceRow,
              ],
            ),
          ),
        ),
      ),
    );

}
