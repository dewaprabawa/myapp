import 'package:flutter/material.dart';
import 'package:myapp/models/partner_model.dart';
import 'package:myapp/services/partner_service.dart';

class PartnerProvider with ChangeNotifier {
  final PartnerService _service = PartnerService();
  List<PartnerData> _partners = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationMeta? _meta;

  List<PartnerData> get partners => _partners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationMeta? get meta => _meta;

  Future<void> fetchPartners(
    String token, {
    String? search,
    bool? isActive,
    int perPage = 15,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getPartners(
        token,
        search: search,
        isActive: isActive,
        perPage: perPage,
      );
      _partners = response.data;
      _meta = response.meta;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPartner(String token, PartnerData partner) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.storePartner(token, partner);
      await fetchPartners(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePartner(String token, PartnerData partner) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updatePartner(token, partner);
      await fetchPartners(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePartner(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deletePartner(token, id);
      await fetchPartners(token);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PartnerData?> fetchPartnerDetail(String token, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getPartnerDetail(token, id);
      return response.data;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
