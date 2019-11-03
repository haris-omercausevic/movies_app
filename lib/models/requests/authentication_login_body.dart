class AuthenticationLoginBody {
  String username;
  String password;
  String deviceId;
  String deviceModel;
  String deviceManufacturer;
  String deviceName;
  String deviceVersion;
  String devicePlatform;
  String playerId;

  AuthenticationLoginBody({
    this.username,
    this.password,
    this.deviceId,
    this.deviceModel,
    this.deviceManufacturer,
    this.deviceName,
    this.deviceVersion,
    this.devicePlatform,
    this.playerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Password": password,
      "DeviceId": deviceId,
      "DeviceModel": deviceModel,
      "DeviceManufacturer": deviceManufacturer,
      "DeviceName": deviceName,
      "DeviceVersion": deviceVersion,
      "DevicePlatform": devicePlatform,
      "PlayerId": playerId,
    };
  }
}
