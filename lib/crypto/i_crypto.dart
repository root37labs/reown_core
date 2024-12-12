import 'package:reown_core/crypto/crypto_models.dart';
import 'package:reown_core/crypto/i_crypto_utils.dart';
import 'package:reown_core/store/i_generic_store.dart';

abstract class ICrypto {
  abstract final String name;

  abstract IGenericStore<String> keyChain;

  Future<void> init();

  bool hasKeys(String tag);
  Future<String> getClientId();
  Future<String> generateKeyPair();
  Future<String> generateSharedKey(
    String selfPublicKey,
    String peerPublicKey, {
    String? overrideTopic,
  });
  Future<String> setSymKey(
    String symKey, {
    String? overrideTopic,
  });
  Future<void> deleteKeyPair(String publicKey);
  Future<void> deleteSymKey(String topic);
  Future<String?> encode(
    String topic,
    Map<String, dynamic> payload, {
    EncodeOptions? options,
  });
  Future<String?> decode(
    String topic,
    String encoded, {
    DecodeOptions? options,
  });
  Future<String> signJWT(String aud);
  int getPayloadType(String encoded);

  String? getPayloadSenderPublicKey(String encoded);

  ICryptoUtils getUtils();
}
