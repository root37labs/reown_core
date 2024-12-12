import 'package:event/event.dart';
import 'package:reown_core/pairing/i_expirer.dart';
import 'package:reown_core/pairing/utils/pairing_models.dart';
import 'package:reown_core/store/generic_store.dart';
import 'package:reown_core/utils/utils.dart';

class Expirer extends GenericStore<int> implements IExpirer {
  @override
  final Event<ExpirationEvent> onExpire = Event();

  Expirer({
    required super.storage,
    required super.context,
    required super.version,
    required super.fromJson,
  });

  @override
  Future<bool> checkExpiry(String key, int expiry) async {
    checkInitialized();

    if (ReownCoreUtils.isExpired(expiry)) {
      await expire(key);
      return true;
    }
    return false;
  }

  /// Checks if the key has expired and deletes it if it has
  /// Returns true if the key was deleted
  /// Returns false if the key was not deleted
  @override
  Future<bool> checkAndExpire(String key) async {
    checkInitialized();

    if (data.containsKey(key)) {
      int expiration = data[key]!;
      if (ReownCoreUtils.isExpired(expiration)) {
        await expire(key);
        return true;
      }
    }

    return false;
  }

  @override
  Future<void> expire(String key) async {
    checkInitialized();

    int? expiry = data.remove(key);
    if (expiry == null) {
      return;
    }
    // print('Expiring $key');
    onExpire.broadcast(
      ExpirationEvent(
        target: key,
        expiry: expiry,
      ),
    );
    await persist();
  }
}
