import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/data/models/client_model.dart';
import 'package:invoiceninja_flutter/data/models/company_model.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/reports/reports_state.dart';
import 'package:invoiceninja_flutter/redux/static/static_state.dart';
import 'package:invoiceninja_flutter/ui/reports/reports_screen.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:memoize/memoize.dart';

class ClientReportFields {
  static const String name = 'name';
  static const String website = 'website';
  static const String currency = 'currency';
  static const String language = 'language';
  static const String privateNotes = 'private_notes';
  static const String publicNotes = 'public_notes';
  static const String industry = 'industry';
  static const String size = 'size';
  static const String address1 = 'address1';
  static const String address2 = 'address2';
  static const String city = 'city';
  static const String state = 'state';
  static const String postCode = 'postal_code';
  static const String phone = 'phone';
  static const String country = 'country';
  static const String shippingAddress1 = 'shipping_address1';
  static const String shippingAddress2 = 'shipping_address2';
  static const String shippingCity = 'shipping_city';
  static const String shippingState = 'shipping_state';
  static const String shippingPostalCode = 'shipping_postal_code';
  static const String shippingCountry = 'shipping_country';
  static const String customValue1 = 'custom_value1';
  static const String customValue2 = 'custom_value2';
  static const String customValue3 = 'custom_value3';
  static const String customValue4 = 'custom_value4';
  static const String createdBy = 'created_by';
  static const String assignedTo = 'assigned_to';
  static const String balance = 'balance';
  static const String creditBalance = 'credit_balance';
  static const String paidToDate = 'paid_to_date';
  static const String idNumber = 'id_number';
  static const String vatNumber = 'vat_number';
  static const String contactFullName = 'contact_full_name';
  static const String contactEmail = 'contact_email';
  static const String contactPhone = 'contact_phone';
  static const String contactCustomValue1 = 'contact_custom_value1';
  static const String contactCustomValue2 = 'contact_custom_value2';
  static const String contactCustomValue3 = 'contact_custom_value3';
  static const String contactCustomValue4 = 'contact_custom_value4';
  static const String contactLastLogin = 'contact_last_login';
  static const String isActive = 'is_active';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

var memoizedClientReport = memo5((
  UserCompanyEntity userCompany,
  ReportsUIState reportsUIState,
  BuiltMap<String, ClientEntity> clientMap,
  BuiltMap<String, UserEntity> userMap,
  StaticState staticState,
) =>
    clientReport(userCompany, reportsUIState, clientMap, userMap, staticState));

ReportResult clientReport(
  UserCompanyEntity userCompany,
  ReportsUIState reportsUIState,
  BuiltMap<String, ClientEntity> clientMap,
  BuiltMap<String, UserEntity> userMap,
  StaticState staticState,
) {
  final List<List<ReportElement>> data = [];
  BuiltList<String> columns;

  final reportSettings = userCompany.settings.reportSettings;
  final clientReportSettings =
      reportSettings != null && reportSettings.containsKey(kReportClient)
          ? reportSettings[kReportClient]
          : ReportSettingsEntity();

  if (clientReportSettings.columns.isNotEmpty) {
    columns = clientReportSettings.columns;
  } else {
    columns = BuiltList(<String>[
      ClientReportFields.name,
      ClientReportFields.contactEmail,
      ClientReportFields.idNumber,
      ClientReportFields.vatNumber,
      ClientReportFields.currency,
      ClientReportFields.balance,
      ClientReportFields.paidToDate,
      ClientReportFields.country,
    ]);
  }

  for (var clientId in clientMap.keys) {
    final client = clientMap[clientId];
    final contact = client.primaryContact;
    if (client.isDeleted) {
      continue;
    }

    bool skip = false;
    final List<ReportElement> row = [];

    for (var column in columns) {
      dynamic value = '';

      switch (column) {
        case ClientReportFields.name:
          value = client.name;
          break;
        case ClientReportFields.website:
          value = client.website;
          break;
        case ClientReportFields.currency:
          value =
              staticState.currencyMap[client.currencyId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.language:
          value =
              staticState.languageMap[client.languageId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.privateNotes:
          value = client.privateNotes;
          break;
        case ClientReportFields.publicNotes:
          value = client.publicNotes;
          break;
        case ClientReportFields.industry:
          value =
              staticState.industryMap[client.industryId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.size:
          value = staticState.sizeMap[client.sizeId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.customValue1:
          value = client.customValue1;
          break;
        case ClientReportFields.customValue2:
          value = client.customValue2;
          break;
        case ClientReportFields.customValue3:
          value = client.customValue3;
          break;
        case ClientReportFields.customValue4:
          value = client.customValue4;
          break;
        case ClientReportFields.address1:
          value = client.address1;
          break;
        case ClientReportFields.address2:
          value = client.address2;
          break;
        case ClientReportFields.city:
          value = client.city;
          break;
        case ClientReportFields.state:
          value = client.state;
          break;
        case ClientReportFields.postCode:
          value = client.postalCode;
          break;
        case ClientReportFields.country:
          value =
              staticState.countryMap[client.countryId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.shippingAddress1:
          value = client.shippingAddress1;
          break;
        case ClientReportFields.shippingAddress2:
          value = client.shippingAddress2;
          break;
        case ClientReportFields.shippingCity:
          value = client.shippingCity;
          break;
        case ClientReportFields.shippingState:
          value = client.shippingState;
          break;
        case ClientReportFields.shippingPostalCode:
          value = client.shippingPostalCode;
          break;
        case ClientReportFields.shippingCountry:
          value = staticState
                  .countryMap[client.shippingCountryId]?.listDisplayName ??
              '';
          break;
        case ClientReportFields.phone:
          value = client.phone;
          break;
        case ClientReportFields.idNumber:
          value = client.idNumber;
          break;
        case ClientReportFields.vatNumber:
          value = client.vatNumber;
          break;
        case ClientReportFields.assignedTo:
          value = userMap[client.assignedUserId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.createdBy:
          value = userMap[client.createdUserId]?.listDisplayName ?? '';
          break;
        case ClientReportFields.contactFullName:
          value = contact.fullName;
          break;
        case ClientReportFields.contactEmail:
          value = contact.email;
          break;
        case ClientReportFields.contactPhone:
          value = contact.phone;
          break;
        case ClientReportFields.contactCustomValue1:
          value = contact.customValue1;
          break;
        case ClientReportFields.contactCustomValue2:
          value = contact.customValue2;
          break;
        case ClientReportFields.contactCustomValue3:
          value = contact.customValue3;
          break;
        case ClientReportFields.contactCustomValue4:
          value = contact.customValue4;
          break;
        case ClientReportFields.contactLastLogin:
          value = convertTimestampToDateString(contact.lastLogin);
          break;
        case ClientReportFields.balance:
          value = client.balance;
          break;
        case ClientReportFields.creditBalance:
          value = client.creditBalance;
          break;
        case ClientReportFields.paidToDate:
          value = client.paidToDate;
          break;
        case ClientReportFields.isActive:
          value = client.isActive;
          break;
        case ClientReportFields.updatedAt:
          value = convertTimestampToDateString(client.updatedAt);
          break;
        case ClientReportFields.createdAt:
          value = convertTimestampToDateString(client.createdAt);
          break;
      }

      if (!ReportResult.matchField(
        value: value,
        userCompany: userCompany,
        reportsUIState: reportsUIState,
        column: column,
      )) {
        skip = true;
      }

      if (value.runtimeType == bool) {
        row.add(client.getReportBool(value: value));
      } else if (value.runtimeType == double) {
        row.add(client.getReportNumber(
            value: value, currencyId: client.settings.currencyId));
      } else {
        row.add(client.getReportString(value: value));
      }
    }

    if (!skip) {
      data.add(row);
    }
  }

  data.sort((rowA, rowB) {
    if (rowA.length <= clientReportSettings.sortIndex ||
        rowB.length <= clientReportSettings.sortIndex) {
      return 0;
    }

    final String valueA = rowA[clientReportSettings.sortIndex].value;
    final String valueB = rowB[clientReportSettings.sortIndex].value;

    if (clientReportSettings.sortAscending) {
      return valueA.compareTo(valueB);
    } else {
      return valueB.compareTo(valueA);
    }
  });

  return ReportResult(
    allColumns: [
      ClientReportFields.name,
      ClientReportFields.website,
      ClientReportFields.currency,
      ClientReportFields.language,
      ClientReportFields.privateNotes,
      ClientReportFields.publicNotes,
      ClientReportFields.industry,
      ClientReportFields.size,
      ClientReportFields.address1,
      ClientReportFields.address2,
      ClientReportFields.city,
      ClientReportFields.state,
      ClientReportFields.postCode,
      ClientReportFields.phone,
      ClientReportFields.country,
      ClientReportFields.shippingAddress1,
      ClientReportFields.shippingAddress2,
      ClientReportFields.shippingCity,
      ClientReportFields.shippingState,
      ClientReportFields.shippingPostalCode,
      ClientReportFields.shippingCountry,
      ClientReportFields.customValue1,
      ClientReportFields.customValue2,
      ClientReportFields.customValue3,
      ClientReportFields.customValue4,
      ClientReportFields.createdBy,
      ClientReportFields.assignedTo,
      ClientReportFields.balance,
      ClientReportFields.creditBalance,
      ClientReportFields.paidToDate,
      ClientReportFields.idNumber,
      ClientReportFields.vatNumber,
      ClientReportFields.contactFullName,
      ClientReportFields.contactEmail,
      ClientReportFields.contactPhone,
      ClientReportFields.contactCustomValue1,
      ClientReportFields.contactCustomValue2,
      ClientReportFields.contactCustomValue3,
      ClientReportFields.contactCustomValue4,
      ClientReportFields.contactLastLogin,
      ClientReportFields.isActive,
      ClientReportFields.createdAt,
      ClientReportFields.updatedAt,
    ],
    columns: columns.toList(),
    data: data,
  );
}