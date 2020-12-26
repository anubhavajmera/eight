import 'package:eight/resources/constants.dart';
import 'package:eight/screens/size_config.dart';
import 'package:eight/src/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class StreamPageMJ extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  /// non-modifiable client role of the page
  final ClientRole role;
  /// Creates a call page with given channel name.
  const StreamPageMJ({Key key, this.channelName, this.role}) : super(key: key);

  @override
  _StreamPageMJState createState() => _StreamPageMJState();
}

class _StreamPageMJState extends State<StreamPageMJ> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    await _engine.joinChannel(Token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    // await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryBrownColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _onToggleMute,
        backgroundColor: Colors.grey,
        tooltip: 'Mike',
        child:
        Container(
          width: 80,
            height: 80,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            )
        ),
        elevation: 8.0,
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.grey,
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.chat_rounded, color: Colors.white,),
                    onPressed: (){}
                ),
                IconButton(
                    icon: Icon(Icons.menu_rounded, color: Colors.white,),
                    onPressed: () => _onCallEnd(context)
                ),
              ]
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(icon: Icon(Icons.navigate_before_rounded), color: Colors.white, iconSize: 40, onPressed: (){
                      Navigator.of(context).pop();
                    }),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text("MJ Yo!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
                        Text("130 viewers", style: TextStyle(color: Colors.yellow, fontSize: 15, fontWeight: FontWeight.w600),),
                        SizedBox(height: 10,)
                      ],
                    ),
                    SizedBox(width: 15,),
                    Container(
                      height: SizeConfig.screenHeight * 0.15,
                      width: SizeConfig.screenHeight * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(width: 30,),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
