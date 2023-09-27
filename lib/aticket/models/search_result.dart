// To parse this JSON data, do
//
//     final searchResult = searchResultFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:jozapp_flutter/utils/etc.dart';

import 'package:jozapp_flutter/models/types.dart';

class SearchResult {
  static List<SearchResult> parserArr(dynamic items) {
    return List<SearchResult>.from((items ?? []).map((x) => SearchResult.fromJson(x)));
  }

  String get sessionId {
    List<AirItinerary> p = airItinerary ?? <AirItinerary>[];
    return (p.isNotEmpty ? p.first.sessionId : null) ?? "NA";
  }

  String get airlineCode {
    return flightSegment?.marketingAirline?.code ?? "w5";
  }

  OriginDestinationOption? get orig {
    var p = originDestinationInformation?.originDestinationOption ?? [];
    return p.isNotEmpty ? p.first : null;
  }
  OriginDestinationOption? get dst {
    var p = originDestinationInformation?.originDestinationOption ?? [];
    return p.isNotEmpty ? p.last : null;
  }

  FlightSegment? get flightSegment {
    List<FlightSegment> p = orig?.flightSegment ?? [];
    return p.isNotEmpty ? p.last : null;
  }

  String get flightNumber => flightSegment?.flightNumber?.toString() ?? "-";
  String get duration {
    // int d = flightSegment?.journeyDurationPerMinute ?? 0;
    // int hours = (d / 60.0).floor();
    // int minutes = d - hours*60;
    // return "${hours}H:${minutes}M " +  (flightSegment?.journeyDuration?.toString() ?? "-");
    return (flightSegment?.journeyDuration?.toString() ?? "-");
  }
  String get departureTime => orig?.departureDateTime?.formatTime ?? "-";
  String get departureDate => orig?.departureDateTime?.formatDate ?? "-";
  String get originLocation => orig?.originLocation ?? "-";
  String get destinationLocation => dst?.destinationLocation ?? "-";
  String get origin => orig?.tpaExtensions?.origin ?? "-";
  String get destination => dst?.tpaExtensions?.destination ?? "-";

  double get totalPrice => airItineraryPricingInfo?.itinTotalFare?.totalFare ?? 0;
  String get currency => airItineraryPricingInfo?.itinTotalFare?.currency ?? "-";

  SearchResult({
    this.airItinerary,
    this.airItineraryPricingInfo,
    this.originDestinationInformation,
  });

  final List<AirItinerary>? airItinerary;
  final AirItineraryPricingInfo? airItineraryPricingInfo;
  final OriginDestinationInformation? originDestinationInformation;

  factory SearchResult.fromRawJson(String str) => SearchResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    airItinerary: List<AirItinerary>.from((json["AirItinerary"] ?? []).map((x) => AirItinerary.fromJson(x))),
    airItineraryPricingInfo: AirItineraryPricingInfo.fromJson(json["AirItineraryPricingInfo"] ?? {}),
    originDestinationInformation: OriginDestinationInformation.fromJson(json["OriginDestinationInformation"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "AirItinerary": List<dynamic>.from((airItinerary ?? []).map((x) => x.toJson())),
    "AirItineraryPricingInfo": airItineraryPricingInfo?.toJson(),
    "OriginDestinationInformation": originDestinationInformation?.toJson(),
  };
}

class AirItinerary {
  AirItinerary({
    this.sessionId,
    this.combinationId,
    this.recommendationId,
    this.subsystemId,
    this.subsystemName,
  });

  final String? sessionId;
  final int? combinationId;
  final int? recommendationId;
  final int? subsystemId;
  final String? subsystemName;

  factory AirItinerary.fromRawJson(String str) => AirItinerary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirItinerary.fromJson(Map<String, dynamic> json) => AirItinerary(
    sessionId: json["SessionId"],
    combinationId: getIntField(json, "CombinationId"),
    recommendationId: getIntField(json, "RecommendationId"),
    subsystemId: getIntField(json, "SubsystemId"),
    subsystemName: json["SubsystemName"],
  );

  Map<String, dynamic> toJson() => {
    "SessionId": sessionId,
    "CombinationId": combinationId,
    "RecommendationId": recommendationId,
    "SubsystemId": subsystemId,
    "SubsystemName": subsystemName,
  };
}

class AirItineraryPricingInfo {
  AirItineraryPricingInfo({
    this.itinTotalFare,
    this.ptcFareBreakdowns,
  });

  final ItinTotalFare? itinTotalFare;
  final List<PtcFareBreakdown>? ptcFareBreakdowns;

  factory AirItineraryPricingInfo.fromRawJson(String str) => AirItineraryPricingInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirItineraryPricingInfo.fromJson(Map<String, dynamic> json) => AirItineraryPricingInfo(
    itinTotalFare: ItinTotalFare.fromJson(json["ItinTotalFare"]),
    ptcFareBreakdowns: List<PtcFareBreakdown>.from(json["PTC_FareBreakdowns"].map((x) => PtcFareBreakdown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ItinTotalFare": itinTotalFare?.toJson(),
    "PTC_FareBreakdowns": List<dynamic>.from((ptcFareBreakdowns ?? []).map((x) => x.toJson())),
  };
}

class ItinTotalFare {
  ItinTotalFare({
    this.baseFare,
    this.totalFare,
    this.totalCommission,
    this.totalTax,
    this.serviceTax,
    this.original,
    this.currency,
  });

  final double? baseFare;
  final double? totalFare;
  final double? totalCommission;
  final double? totalTax;
  final double? serviceTax;
  final double? original;
  final String? currency;

  factory ItinTotalFare.fromRawJson(String str) => ItinTotalFare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItinTotalFare.fromJson(Map<String, dynamic> json) => ItinTotalFare(
    baseFare: getDoubleField(json, "BaseFare"),
    totalFare: getDoubleField(json, "TotalFare"),
    totalCommission: getDoubleField(json, "TotalCommission"),
    totalTax: getDoubleField(json, "TotalTax"),
    serviceTax: getDoubleField(json, "ServiceTax"),
    original: getDoubleField(json, "Original"),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "BaseFare": baseFare,
    "TotalFare": totalFare,
    "TotalCommission": totalCommission,
    "TotalTax": totalTax,
    "ServiceTax": serviceTax,
    "Original": original,
    "Currency": currency,
  };
}

class PtcFareBreakdown {
  PtcFareBreakdown({
    this.passengerFare,
    this.passengerTypeQuantity,
  });

  final PassengerFare? passengerFare;
  final PassengerTypeQuantity? passengerTypeQuantity;

  factory PtcFareBreakdown.fromRawJson(String str) => PtcFareBreakdown.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PtcFareBreakdown.fromJson(Map<String, dynamic> json) => PtcFareBreakdown(
    passengerFare: PassengerFare.fromJson(json["PassengerFare"] ?? {}),
    passengerTypeQuantity: PassengerTypeQuantity.fromJson(json["PassengerTypeQuantity"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "PassengerFare": passengerFare?.toJson(),
    "PassengerTypeQuantity": passengerTypeQuantity?.toJson(),
  };
}

class PassengerFare {
  PassengerFare({
    this.baseFare,
    this.totalFare,
    this.commission,
    this.serviceTax,
    this.taxes,
    this.currency,
  });

  final double? baseFare;
  final double? totalFare;
  final double? commission;
  final double? serviceTax;
  final double? taxes;
  final String? currency;

  factory PassengerFare.fromRawJson(String str) => PassengerFare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengerFare.fromJson(Map<String, dynamic> json) => PassengerFare(
    baseFare: getDoubleField(json, "BaseFare"),
    totalFare: getDoubleField(json, "TotalFare"),
    commission: getDoubleField(json, "Commission"),
    serviceTax: getDoubleField(json, "ServiceTax"),
    taxes: getDoubleField(json, "Taxes"),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "BaseFare": baseFare,
    "TotalFare": totalFare,
    "Commission": commission,
    "ServiceTax": serviceTax,
    "Taxes": taxes,
    "Currency": currency,
  };
}

class PassengerTypeQuantity {
  PassengerTypeQuantity({
    this.code,
    this.quantity,
  });

  final String? code;
  final int? quantity;

  factory PassengerTypeQuantity.fromRawJson(String str) => PassengerTypeQuantity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengerTypeQuantity.fromJson(Map<String, dynamic> json) => PassengerTypeQuantity(
    code: json["Code"],
    quantity: getIntField(json, "Quantity"),
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Quantity": quantity,
  };
}

class OriginDestinationInformation {
  OriginDestinationInformation({
    this.originDestinationOption,
  });

  final List<OriginDestinationOption>? originDestinationOption;

  factory OriginDestinationInformation.fromRawJson(String str) => OriginDestinationInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OriginDestinationInformation.fromJson(Map<String, dynamic> json) => OriginDestinationInformation(
    originDestinationOption: List<OriginDestinationOption>.from((json["OriginDestinationOption"] ?? []).map((x) => OriginDestinationOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "OriginDestinationOption": List<dynamic>.from((originDestinationOption ?? []).map((x) => x.toJson())),
  };
}

class OriginDestinationOption {
  OriginDestinationOption({
    this.departureDateTime,
    this.departureDateG,
    this.departureDateJ,
    this.arrivalDateTime,
    this.arrivalDateG,
    this.arrivalDateJ,
    this.journeyDuration,
    this.journeyDurationPerMinute,
    this.originLocation,
    this.destinationLocation,
    this.tpaExtensions,
    this.flightSegment,
  });

  final DateTime? departureDateTime;
  final String? departureDateG;
  final String? departureDateJ;
  final DateTime? arrivalDateTime;
  final String? arrivalDateG;
  final String? arrivalDateJ;
  final String? journeyDuration;
  final int? journeyDurationPerMinute;
  final String? originLocation;
  final String? destinationLocation;
  final OriginDestinationOptionTpaExtensions? tpaExtensions;
  final List<FlightSegment>? flightSegment;

  factory OriginDestinationOption.fromRawJson(String str) => OriginDestinationOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OriginDestinationOption.fromJson(Map<String, dynamic> json) => OriginDestinationOption(
    departureDateTime: getDateTimeField(json, "DepartureDateTime"),
    departureDateG: json["DepartureDateG"],
    departureDateJ: json["DepartureDateJ"],
    arrivalDateTime: getDateTimeField(json, "ArrivalDateTime"),
    arrivalDateG: json["ArrivalDateG"],
    arrivalDateJ: json["ArrivalDateJ"],
    journeyDuration: json["JourneyDuration"],
    journeyDurationPerMinute: getIntField(json, "JourneyDurationPerMinute"),
    originLocation: json["OriginLocation"],
    destinationLocation: json["DestinationLocation"],
    tpaExtensions: OriginDestinationOptionTpaExtensions.fromJson(json["TPA_Extensions"] ?? {}),
    flightSegment: List<FlightSegment>.from((json["FlightSegment"] ?? []).map((x) => FlightSegment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DepartureDateTime": departureDateTime?.toIso8601String(),
    "DepartureDateG": departureDateG,
    "DepartureDateJ": departureDateJ,
    "ArrivalDateTime": arrivalDateTime?.toIso8601String(),
    "ArrivalDateG": arrivalDateG,
    "ArrivalDateJ": arrivalDateJ,
    "JourneyDuration": journeyDuration,
    "JourneyDurationPerMinute": journeyDurationPerMinute,
    "OriginLocation": originLocation,
    "DestinationLocation": destinationLocation,
    "TPA_Extensions": tpaExtensions?.toJson(),
    "FlightSegment": List<dynamic>.from((flightSegment ?? []).map((x) => x.toJson())),
  };
}

class FlightSegment {
  FlightSegment({
    this.departureDateTime,
    this.arrivalDateTime,
    this.flightNumber,
    this.resBookDesigCode,
    this.journeyDuration,
    this.journeyDurationPerMinute,
    this.connectionTime,
    this.connectionTimePerMinute,
    this.departureAirport,
    this.arrivalAirport,
    this.marketingAirline,
    this.cabinClassCode,
    this.operatingAirline,
    this.tpaExtensions,
    this.comment,
    this.equipment,
    this.seatsRemaining,
    this.bookingClassAvail,
    this.marketingCabin,
  });

  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;
  final int? flightNumber;
  final String? resBookDesigCode;
  final String? journeyDuration;
  final int? journeyDurationPerMinute;
  final String? connectionTime;
  final int? connectionTimePerMinute;
  final _Airport? departureAirport;
  final _Airport? arrivalAirport;
  final MarketingAirline? marketingAirline;
  final String? cabinClassCode;
  final OperatingAirline? operatingAirline;
  final FlightSegmentTpaExtensions? tpaExtensions;
  final dynamic comment;
  final Equipment? equipment;
  final String? seatsRemaining;
  final BookingClassAvail? bookingClassAvail;
  final MarketingCabin? marketingCabin;

  factory FlightSegment.fromRawJson(String str) => FlightSegment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      departureDateTime: getDateTimeField(json, "DepartureDateTime"),
      arrivalDateTime: getDateTimeField(json, "ArrivalDateTime"),
      flightNumber: getIntField(json, "FlightNumber"),
      resBookDesigCode: json["ResBookDesigCode"],
      journeyDuration: json["JourneyDuration"],
      journeyDurationPerMinute: getIntField(json, "JourneyDurationPerMinute"),
      connectionTime: json["ConnectionTime"],
      connectionTimePerMinute: getIntField(json, "ConnectionTimePerMinute"),
      departureAirport: _Airport.fromJson(json["DepartureAirport"] ?? {}),
      arrivalAirport: _Airport.fromJson(json["ArrivalAirport"] ?? {}),
      marketingAirline: MarketingAirline.fromJson(
          json["MarketingAirline"] ?? {}),
      cabinClassCode: json["CabinClassCode"],
      operatingAirline: OperatingAirline.fromJson(
          json["OperatingAirline"] ?? {}),
      tpaExtensions: FlightSegmentTpaExtensions.fromJson(
          json["TPA_Extensions"] ?? {}),
      comment: json["comment"],
      equipment: Equipment.fromJson(json["Equipment"] ?? {}),
      seatsRemaining: json["SeatsRemaining"]?.toString(),
      bookingClassAvail: BookingClassAvail.fromJson(
          json["BookingClassAvail"] ?? {}),
      marketingCabin: MarketingCabin.fromJson(json["MarketingCabin"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "DepartureDateTime": departureDateTime?.toIso8601String(),
    "ArrivalDateTime": arrivalDateTime?.toIso8601String(),
    "FlightNumber": flightNumber,
    "ResBookDesigCode": resBookDesigCode,
    "JourneyDuration": journeyDuration,
    "JourneyDurationPerMinute": journeyDurationPerMinute,
    "ConnectionTime": connectionTime,
    "ConnectionTimePerMinute": connectionTimePerMinute,
    "DepartureAirport": departureAirport?.toJson(),
    "ArrivalAirport": arrivalAirport?.toJson(),
    "MarketingAirline": marketingAirline?.toJson(),
    "CabinClassCode": cabinClassCode,
    "OperatingAirline": operatingAirline?.toJson(),
    "TPA_Extensions": tpaExtensions?.toJson(),
    "comment": comment,
    "Equipment": equipment?.toJson(),
    "SeatsRemaining": seatsRemaining,
    "BookingClassAvail": bookingClassAvail?.toJson(),
    "MarketingCabin": marketingCabin?.toJson(),
  };
}

class _Airport {
  _Airport({
    this.locationCode,
    this.airportName,
    this.terminal,
    this.gate,
    this.codeContext,
  });

  final String? locationCode;
  final String? airportName;
  final String? terminal;
  final String? gate;
  final String? codeContext;

  String toRawJson() => json.encode(toJson());

  factory _Airport.fromJson(Map<String, dynamic> json) => _Airport(
    locationCode: json["LocationCode"],
    airportName: json["AirportName"],
    terminal: json["Terminal"]?.toString(),
    gate: json["Gate"],
    codeContext: json["CodeContext"],
  );

  Map<String, dynamic> toJson() => {
    "LocationCode": locationCode,
    "AirportName": airportName,
    "Terminal": terminal,
    "Gate": gate,
    "CodeContext": codeContext,
  };
}

class BookingClassAvail {
  BookingClassAvail({
    this.resBookDesigCode,
    this.resBookDesigQuantity,
    this.resBookDesigStatusCode,
    this.meal,
  });

  final String? resBookDesigCode;
  final dynamic resBookDesigQuantity;
  final dynamic resBookDesigStatusCode;
  final dynamic meal;

  factory BookingClassAvail.fromRawJson(String str) => BookingClassAvail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingClassAvail.fromJson(Map<String, dynamic> json) => BookingClassAvail(
    resBookDesigCode: json["ResBookDesigCode"],
    resBookDesigQuantity: json["ResBookDesigQuantity"],
    resBookDesigStatusCode: json["ResBookDesigStatusCode"],
    meal: json["Meal"],
  );

  Map<String, dynamic> toJson() => {
    "ResBookDesigCode": resBookDesigCode,
    "ResBookDesigQuantity": resBookDesigQuantity,
    "ResBookDesigStatusCode": resBookDesigStatusCode,
    "Meal": meal,
  };
}

class Equipment {
  Equipment({
    this.aircraftTailNumber,
    this.airEquipType,
    this.changeofGauge,
  });

  final String? aircraftTailNumber;
  final String? airEquipType;
  final dynamic changeofGauge;

  factory Equipment.fromRawJson(String str) => Equipment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    aircraftTailNumber: json["AircraftTailNumber"],
    airEquipType: json["AirEquipType"],
    changeofGauge: json["ChangeofGauge"],
  );

  Map<String, dynamic> toJson() => {
    "AircraftTailNumber": aircraftTailNumber,
    "AirEquipType": airEquipType,
    "ChangeofGauge": changeofGauge,
  };
}

class MarketingAirline {
  MarketingAirline({
    this.code,
    this.companyShortName,
  });

  final String? code;
  final String? companyShortName;

  factory MarketingAirline.fromRawJson(String str) => MarketingAirline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarketingAirline.fromJson(Map<String, dynamic> json) => MarketingAirline(
    code: json["Code"],
    companyShortName: json["CompanyShortName"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "CompanyShortName": companyShortName,
  };
}

class MarketingCabin {
  MarketingCabin({
    this.meal,
    this.flightLoadInfo,
    this.baggageAllowance,
  });

  final dynamic meal;
  final FlightLoadInfo? flightLoadInfo;
  final BaggageAllowance? baggageAllowance;

  factory MarketingCabin.fromRawJson(String str) => MarketingCabin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarketingCabin.fromJson(Map<String, dynamic> json) => MarketingCabin(
    meal: json["Meal"],
    flightLoadInfo: FlightLoadInfo.fromJson(json["FlightLoadInfo"] ?? {}),
    baggageAllowance: BaggageAllowance.fromJson(json["BaggageAllowance"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "Meal": meal,
    "FlightLoadInfo": flightLoadInfo?.toJson(),
    "BaggageAllowance": baggageAllowance?.toJson(),
  };
}

class BaggageAllowance {
  BaggageAllowance({
    this.unitOfMeasure,
    this.unitOfMeasureCode,
    this.unitOfMeasureQuantity,
  });

  final String? unitOfMeasure;
  final String? unitOfMeasureCode;
  final String? unitOfMeasureQuantity;

  factory BaggageAllowance.fromRawJson(String str) => BaggageAllowance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BaggageAllowance.fromJson(Map<String, dynamic> json) => BaggageAllowance(
    unitOfMeasure: json["UnitOfMeasure"]?.toString(),
    unitOfMeasureCode: json["UnitOfMeasureCode"]?.toString(),
    unitOfMeasureQuantity: json["UnitOfMeasureQuantity"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "UnitOfMeasure": unitOfMeasure,
    "UnitOfMeasureCode": unitOfMeasureCode,
    "UnitOfMeasureQuantity": unitOfMeasureQuantity,
  };
}

class FlightLoadInfo {
  FlightLoadInfo({
    this.authorizedSeatQty,
    this.revenuePaxQty,
  });

  final dynamic authorizedSeatQty;
  final dynamic revenuePaxQty;

  factory FlightLoadInfo.fromRawJson(String str) => FlightLoadInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightLoadInfo.fromJson(Map<String, dynamic> json) => FlightLoadInfo(
    authorizedSeatQty: json["AuthorizedSeatQty"],
    revenuePaxQty: json["RevenuePaxQty"],
  );

  Map<String, dynamic> toJson() => {
    "AuthorizedSeatQty": authorizedSeatQty,
    "RevenuePaxQty": revenuePaxQty,
  };
}

class OperatingAirline {
  OperatingAirline({
    this.code,
    this.flightNumber,
    this.companyShortName,
  });

  final String? code;
  final int? flightNumber;
  final String? companyShortName;

  factory OperatingAirline.fromRawJson(String str) => OperatingAirline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OperatingAirline.fromJson(Map<String, dynamic> json) => OperatingAirline(
    code: json["Code"],
    flightNumber: getIntField(json, "FlightNumber"),
    companyShortName: json["CompanyShortName"],
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "FlightNumber": flightNumber,
    "CompanyShortName": companyShortName,
  };
}

class FlightSegmentTpaExtensions {
  FlightSegmentTpaExtensions({
    this.origin,
    this.destination,
    this.departureDateG,
    this.departureDateJ,
    this.arrivalDateG,
    this.arrivalDateJ,
    this.flightTime,
    this.arrivalTime,
    this.airlineNameFa,
  });

  final String? origin;
  final String? destination;
  final String? departureDateG;
  final String? departureDateJ;
  final String? arrivalDateG;
  final String? arrivalDateJ;
  final String? flightTime;
  final String? arrivalTime;
  final String? airlineNameFa;

  factory FlightSegmentTpaExtensions.fromRawJson(String str) => FlightSegmentTpaExtensions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightSegmentTpaExtensions.fromJson(Map<String, dynamic> json) => FlightSegmentTpaExtensions(
    origin: json["Origin"],
    destination: json["Destination"],
    departureDateG: json["DepartureDateG"],
    departureDateJ: json["DepartureDateJ"],
    arrivalDateG: json["ArrivalDateG"],
    arrivalDateJ: json["ArrivalDateJ"],
    flightTime: json["FlightTime"],
    arrivalTime: json["ArrivalTime"],
    airlineNameFa: json["AirlineNameFa"],
  );

  Map<String, dynamic> toJson() => {
    "Origin": origin,
    "Destination": destination,
    "DepartureDateG": departureDateG,
    "DepartureDateJ": departureDateJ,
    "ArrivalDateG": arrivalDateG,
    "ArrivalDateJ": arrivalDateJ,
    "FlightTime": flightTime,
    "ArrivalTime": arrivalTime,
    "AirlineNameFa": airlineNameFa,
  };
}

class OriginDestinationOptionTpaExtensions {
  OriginDestinationOptionTpaExtensions({
    this.origin,
    this.destination,
    this.agencyCode,
    this.flightType,
    this.isForeign,
    this.isLock,
    this.stop,
  });

  final String? origin;
  final String? destination;
  final dynamic agencyCode;
  final String? flightType;
  final bool? isForeign;
  final bool? isLock;
  final int? stop;

  factory OriginDestinationOptionTpaExtensions.fromRawJson(String str) => OriginDestinationOptionTpaExtensions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OriginDestinationOptionTpaExtensions.fromJson(Map<String, dynamic> json) => OriginDestinationOptionTpaExtensions(
    origin: json["Origin"],
    destination: json["Destination"],
    agencyCode: json["AgencyCode"],
    flightType: json["FlightType"],
    isForeign: json["IsForeign"],
    isLock: json["IsLock"],
    stop: getIntField(json, "Stop"),
  );

  Map<String, dynamic> toJson() => {
    "Origin": origin,
    "Destination": destination,
    "AgencyCode": agencyCode,
    "FlightType": flightType,
    "IsForeign": isForeign,
    "IsLock": isLock,
    "Stop": stop,
  };
}
