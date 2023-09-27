import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/airport.dart';
import 'package:jozapp_flutter/aticket/models/book_result.dart';
import 'package:jozapp_flutter/aticket/models/passenger.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';


class TicketModel extends ChangeNotifier {
  static TicketModel get i => Provider.of<TicketModel>(Get.context!, listen: false);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Airport? _from;
  Airport? get from => _from;
  set from(Airport? value) {
    _from = value;
    notifyListeners();
  }

  Airport? _to;
  Airport? get to => _to;
  set to(Airport? value) {
    _to = value;
    notifyListeners();
  }

  int _adultCount = 1;
  int get adultCount => _adultCount;
  set adultCount(int value) {
    _adultCount = value;
    notifyListeners();
  }

  int _childCount = 0;
  int get childCount => _childCount;
  set childCount(int value) {
    _childCount = value;
    notifyListeners();
  }

  int _infantCount = 0;
  int get infantCount => _infantCount;
  set infantCount(int value) {
    _infantCount = value;
    notifyListeners();
  }

  int _dirType = 0;
  int get dirType => _dirType;
  set dirType(int value) {
    _dirType = value;
    notifyListeners();
  }

  int _flightType = 2;
  int get flightType => _flightType;
  set flightType(int value) {
    _flightType = value;
    notifyListeners();
  }

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;
  set fromDate(DateTime? value) {
    _fromDate = value;
    notifyListeners();
  }

  DateTime? _toDate;
  DateTime? get toDate => _toDate;
  set toDate(DateTime? value) {
    _toDate = value;
    notifyListeners();
  }

  int _flightClass = 0;
  int get flightClass => _flightClass;
  set flightClass(int value) {
    _flightClass = value;
    notifyListeners();
  }

  void clear() {
    _loading = false;
    _from = null;
    _to = null;
    _fromDate = null;
    _toDate = null;
    _dirType = 0;
    _flightClass = 0;
    _flightType = 2;
    _adultCount = 1;
    _childCount = 0;
    _infantCount = 0;

    _searchResult = null;
  }


  void setPassenger(Passenger p, int index) {
    _passengers[p.type][index] = p;
    notifyListeners();
  }

  List<String> get passengerErrors {
    List<String> e = [];
    for(int type=0; type<3; type++) {
      var list = _passengers[type];
      var len = list.length;
      for(int i=0; i<len; i++) {
        var p = list[i];
        if(p.isEmpty) e.add("${p.typeString} number ${i+1} cannot left empty");
      }
    }
    return e;
  }

  final List<List<Passenger>> _passengers = <List<Passenger>>[
    <Passenger>[],
    <Passenger>[],
    <Passenger>[],
  ];


  List<Passenger> getPassengers(int type) => _passengers[type];

  List<Passenger> get adults => _passengers[0];
  set adults(List<Passenger> value) {
    _passengers[0] = value;
    notifyListeners();
  }

  List<Passenger> get children => _passengers[1];
  set children(List<Passenger> value) {
    _passengers[1] = value;
    notifyListeners();
  }

  List<Passenger> get infants => _passengers[2];
  set infants(List<Passenger> value) {
    _passengers[2] = value;
    notifyListeners();
  }

  int _getPassengersCount(int type) {
    return type == 0 ? _adultCount : type == 1 ?_childCount : _infantCount;
  }

  void initPassengers() {
    for(int type=0; type<3; type++) {
      // _passengers[type].clear();
      int cnt = _getPassengersCount(type);
      while (_passengers[type].length < cnt) {
        _passengers[type].add(Passenger.empty(type));
      }
      _passengers[type].removeRange(cnt, _passengers[type].length);
    }
  }



  List<SearchResult>? _searchResult;
  List<SearchResult>? get searchResult => _searchResult;
  set searchResult(List<SearchResult>? value) {
    _searchResult = value;
    notifyListeners();
  }

  SearchResult? _selectedResult;
  SearchResult? get selectedResult => _selectedResult;
  set selectedResult(SearchResult? value) {
    _selectedResult = value;
    initPassengers();
    notifyListeners();
  }

  BookResult? _bookResult;
  BookResult? get bookResult => _bookResult;
  set bookResult(BookResult? value) {
    _bookResult = value;
    notifyListeners();
  }

  List<String> get searchErrors {
    List<String> all = [];
    if(from == null) all.add("Please Select Departure Airport");
    if(to == null) all.add("Please Select Arrival Airport");
    if(fromDate == null) all.add("Please Select Depart date");
    if(dirType == 1 && toDate == null) all.add("Please Select return date");
    if(dirType == 1 && toDate != null && fromDate != null && fromDate!.getDay.isAfter(toDate!)) all.add("Return date must be after Depart date");
    return all;
  }

  List<Json> get originDestinationInformations {
    Json originLocation = from?.getLocation ?? {};
    Json destinationLocation = to?.getLocation ?? {};

    Json odi1 = {
      "OriginLocation": originLocation,
      "DestinationLocation": destinationLocation,
      "DepartureDateTime": fromDate?.formatFormalDate,
      "ArrivalDateTime": null,
    };

    return dirType == 0 ? [odi1] : [odi1, {
    "OriginLocation": destinationLocation,
    "DestinationLocation": originLocation,
    "DepartureDateTime": toDate?.formatFormalDate,
    "ArrivalDateTime": null,
    }];
  }

  Json get searchOptions {
    return {
      "Lang": "FA",
      "TravelPreference": {
        "CabinPref": {
          "Cabin": "Economy"
        },
        "EquipPref": {
          "AirEquipType": "IATA"
        },
        "FlightTypePref": {
          "BackhaulIndicator": "",
          "DirectAndNonStopOnlyInd": false,
          "ExcludeTrainInd": false,
          "GroundTransportIndicator": false,
          "MaxConnections": 3
        }
      },
      "TravelerInfoSummary": {
        "AirTravelerAvail": {
          "PassengerTypeQuantity": [
            {
              "Code": "ADT",
              "Quantity": adultCount
            },
            {
              "Code": "CHD",
              "Quantity": childCount
            },
            {
              "Code": "INF",
              "Quantity": infantCount
            }
          ]
        }
      },
      "SpecificFlightInfo": {
        "Airline": []
      },
      "OriginDestinationInformations": originDestinationInformations,
    };
  }

  Future<bool> doSearch()  async {
    loading = true;
    // log(jsonEncode(TicketModel.i.searchOptions));
    var resp = await AticketApi.getSearch(searchOptions);
    loading = false;

    if(!(resp.success ?? false)) {
      showErrors([resp.items?.toString() ?? "-"]);
      return false;
    }

    searchResult = (resp.items ?? <SearchResult>[]) as List<SearchResult>;

    return true;
  }



  Future<Json> get bookData async {

    Json data = selectedResult?.toJson() ?? {};
    var airItinerary = data["AirItinerary"];

    PhoneNumber phoneNumber = await PhoneNumberUtil().parse(RestApi.appModel.user?.phone ?? "+989133834091");


    return {
      "Discount": {
        "CoponCode": "kaskas"
      },
      "Owner": {
        "Contacts": [
          {
            "Email": "wallet@bahbahan.com",
            "Telephone": {
              "PhoneTechType": "Mobile",
              "PhoneNumber": phoneNumber.nationalNumber,
              "CountryAccessCode": "00"+phoneNumber.countryCode,
              "AreaCityCode": ""
            }
          }
        ]
      },
      "Transports": {
        "AirItinerary": airItinerary,
        "Ticketing": {
          "TicketType": "BookingOnly"
        },
        //"Captcha": null,
        "TravelerInfo": {
          "AirTraveler": List<dynamic>.from([..._passengers[0], ..._passengers[1], ..._passengers[2]].map((x) => x.toDoc()))
        }
      },
      "currencyToPay": selectedResult?.currency ?? "USD"
    };
  }


}