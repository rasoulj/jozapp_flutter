import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/models/ticket_result.dart';
import 'package:jozapp_flutter/models/types.dart';

import 'book_result.dart';

class Ticket {
  final String? id;
  final SearchResult? search;
  final TicketResult? book;
  final double? usdPrice;
  final String? loggedUid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Ticket({
    this.book,
    this.id,
    this.search,
    this.usdPrice,
    this.loggedUid,
    this.createdAt,
    this.updatedAt,
  });

  factory Ticket.fromJson(Json json) => Ticket(
    id: json["_id"],
    search: SearchResult.fromJson(json["result"] ?? {}),
    book: TicketResult.fromJson(json["data"] ?? {}),
    usdPrice: getDoubleField(json, "usdPrice"),
    loggedUid: json["logged_uid"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}
