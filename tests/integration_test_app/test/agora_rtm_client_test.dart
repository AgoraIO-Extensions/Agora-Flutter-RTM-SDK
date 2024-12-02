import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Can get xor value from RtmConfig.areaCode', () {
    const config = RtmConfig(areaCode: {RtmAreaCode.cn, RtmAreaCode.na});
    final json = config.toJson();
    expect(json['areaCode'], RtmAreaCode.cn.value() | RtmAreaCode.na.value());
  });

  test('Can get xor value from RtmPrivateConfig.serviceType', () {
    const config = RtmPrivateConfig(
        serviceType: {RtmServiceType.message, RtmServiceType.stream});
    final json = config.toJson();
    expect(json['serviceType'],
        RtmServiceType.message.value() | RtmServiceType.stream.value());
  });
}
