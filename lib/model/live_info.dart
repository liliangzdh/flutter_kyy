class LiveInfo {
  int access; //0 | 1;
  String startTime;
  int liveID;
  int playbackId;
  int free = 0; //0 | 1 | '0' | '1';
  String type;

  LiveInfo(this.access, this.startTime, this.liveID, this.free);

}
