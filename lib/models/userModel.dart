import 'package:eight/models/channelModel.dart';

class UserModel {
  String username, phone, userImage;
  List<ChannelModel> channels;

  UserModel(this.username, this.phone, this.userImage, this.channels);
}
