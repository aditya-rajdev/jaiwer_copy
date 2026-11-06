import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopModel {
  const ShopModel({
    required this.id,
    required this.name,
    required this.branch,
    required this.address,
    required this.phone,
    required this.gstin,
    required this.isPrimary,
  });

  final String id;
  final String name;
  final String branch;
  final String address;
  final String phone;
  final String gstin;
  final bool isPrimary;

  String get displayName => name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'branch': branch,
        'address': address,
        'phone': phone,
        'gstin': gstin,
        'isPrimary': isPrimary,
      };

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: (json['id'] ?? 'shop_primary').toString(),
        name: (json['name'] ?? 'JAIWER Jewellery Shop').toString(),
        branch: (json['branch'] ?? 'Main Branch').toString(),
        address: (json['address'] ?? 'Patna, Bihar').toString(),
        phone: (json['phone'] ?? '+919876543210').toString(),
        gstin: (json['gstin'] ?? '10AAAAA0000A1Z5').toString(),
        isPrimary: true,
      );
}

class ShopContextService extends ChangeNotifier {
  ShopContextService._internal();
  static final ShopContextService instance = ShopContextService._internal();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  ShopModel? _currentShop;

  // Single-Shop Enforcement: Only one shop is returned per account
  List<ShopModel> get shops => _currentShop != null ? [_currentShop!] : [_defaultSingleShop()];
  ShopModel? get currentShop => _currentShop ?? _defaultSingleShop();
  String get selectedShopId => _currentShop?.id ?? 'shop_primary';
  bool get isSingleShopMode => true;

  Future<void> initialize() async {
    final storedName = await _storage.read(key: 'shop_name');
    final storedAddress = await _storage.read(key: 'shop_address');

    final name = (storedName != null && storedName.trim().isNotEmpty)
        ? storedName.trim()
        : 'JAIWER Jewellery Shop';

    final address = (storedAddress != null && storedAddress.trim().isNotEmpty)
        ? storedAddress.trim()
        : 'Patna, Bihar';

    _currentShop = ShopModel(
      id: 'shop_primary',
      name: name,
      branch: 'Main Branch',
      address: address,
      phone: '+91 98765 43210',
      gstin: '10AAAAA0000A1Z5',
      isPrimary: true,
    );

    await _storage.write(key: 'selected_shop_id', value: 'shop_primary');
    notifyListeners();
  }

  ShopModel _defaultSingleShop() {
    return const ShopModel(
      id: 'shop_primary',
      name: 'JAIWER Jewellery Shop',
      branch: 'Main Branch',
      address: 'Patna, Bihar',
      phone: '+91 98765 43210',
      gstin: '10AAAAA0000A1Z5',
      isPrimary: true,
    );
  }

  Future<bool> switchShop(String shopId) async {
    // Multi-shop switching is disabled in Single-Shop mode
    debugPrint('[ShopContextService] Multi-shop switching is temporarily disabled (Single-Shop mode).');
    return false;
  }

  Future<bool> addNewShop(ShopModel shop) async {
    // Multi-shop creation is disabled in Single-Shop mode
    debugPrint('[ShopContextService] Adding multiple shops is temporarily disabled (Single-Shop mode).');
    return false;
  }
}
