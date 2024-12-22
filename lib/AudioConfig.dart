
class AudioConfig {
  List<PlayList>? playList;
  List<FileData>? folderConfig;
  SongConfig? audioMaster;

  AudioConfig({this.playList, this.folderConfig, this.audioMaster});

  AudioConfig.fromJson(Map<String, dynamic> json) {
    if (json['PlayList'] != null) {
      playList = <PlayList>[];
      json['PlayList'].forEach((v) {
        playList!.add(new PlayList.fromJson(v));
      });
    }

    if(json['FolderConfig'] != null)
    {
      folderConfig = <FileData>[];
      json['FolderConfig'].forEach((key, value){
        folderConfig!.add(new FileData.fromJson(key, value));
      });
    }

    // folderConfig = json['FolderConfig'] != null
    //     ? new  FolderConfig.fromJson(json['FolderConfig'])
    //     : null;
    audioMaster = json['AudioMaster'] != null
        ? new SongConfig.fromJson(json['AudioMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.playList != null) {
      data['PlayList'] = this.playList!.map((v) => v.toJson()).toList();
    }

     if (this.folderConfig != null) {
      final Map<String, dynamic> fdata = new Map<String, dynamic>();
      this.folderConfig!.forEach((e) {
        fdata[e.types] = e.data;
      });
      data['FolderConfig'] = fdata;
    }

    // if (this.folderConfig != null) {
    //   data['FolderConfig'] = this.folderConfig!.toJson();
    // }
    if (this.audioMaster != null) {
      data['AudioMaster'] = this.audioMaster!.toJson();
    }
    return data;
  }
}

class PlayList {
  bool? isPlay;
  List<FileData>? fileData;

  PlayList({this.isPlay, this.fileData});

  PlayList.fromJson(Map<String, dynamic> json) {
    isPlay = json['isPlay'];

    if (json['SongConfig'] != null) {
      fileData = <FileData>[];
      json['SongConfig'].forEach((key, value) {
        this.fileData!.add(new FileData.fromJson(key, value));
      });
    }

    // print(fileData!.length);
      }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPlay'] = this.isPlay;
    if (this.fileData != null) {
      final Map<String, dynamic> fdata = new Map<String, dynamic>();
      this.fileData!.forEach((e) {
        fdata[e.types] = e.data;
      });
      data['SongConfig'] = fdata;
    }
    return data;
  }
}

class SongConfig {
  List<dynamic>? sS;
  List<dynamic>? vO;
  List<dynamic>? hR;
  List<dynamic>? mO;
  List<dynamic>? dT;
  List<dynamic>? dW;
  List<dynamic>? pN;
  List<dynamic>? sN1;
  List<dynamic>? sN2;
  List<dynamic>? sN3;
  List<dynamic>? sN4;
  List<dynamic>? sN5;
  List<dynamic>? sN6;
  List<dynamic>? sN7;
  List<dynamic>? dWS;

  SongConfig(
      {this.sS,
      this.vO,
      this.hR,
      this.mO,
      this.dT,
      this.dW,
      this.pN,
      this.sN1,
      this.sN2,
      this.sN3,
      this.sN4,
      this.sN5,
      this.sN6,
      this.sN7,
      this.dWS});

  SongConfig.fromJson(Map<String, dynamic> json) {
    sS = json['SS'].cast<dynamic>();
    vO = json['VO'].cast<dynamic>();
    hR = json['HR'].cast<dynamic>();
    mO = json['MO'].cast<dynamic>();
    dT = json['DT'].cast<dynamic>();
    dW = json['DW'].cast<dynamic>();
    pN = json['PN'].cast<dynamic>();
    sN1 = json['SN1'].cast<dynamic>();
    sN2 = json['SN2'].cast<dynamic>();
    sN3 = json['SN3'].cast<dynamic>();
    sN4 = json['SN4'].cast<dynamic>();
    sN5 = json['SN5'].cast<dynamic>();
    sN6 = json['SN6'].cast<dynamic>();
    sN7 = json['SN7'].cast<dynamic>();
    dWS = json['DWS'].cast<dynamic>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SS'] = this.sS;
    data['VO'] = this.vO;
    data['HR'] = this.hR;
    data['MO'] = this.mO;
    data['DT'] = this.dT;
    data['DW'] = this.dW;
    data['PN'] = this.pN;
    data['SN1'] = this.sN1;
    data['SN2'] = this.sN2;
    data['SN3'] = this.sN3;
    data['SN4'] = this.sN4;
    data['SN5'] = this.sN5;
    data['SN6'] = this.sN6;
    data['SN7'] = this.sN7;
    data['DWS'] = this.dWS;
    return data;
  }
}

class FolderConfig {
  List<dynamic>? sN1;
  List<dynamic>? sN2;
  List<dynamic>? sN3;
  List<dynamic>? sN4;
  List<dynamic>? sN5;
  List<dynamic>? sN6;
  List<dynamic>? sN7;
  List<dynamic>? dWS;

  FolderConfig(
      {this.sN1,
      this.sN2,
      this.sN3,
      this.sN4,
      this.sN5,
      this.sN6,
      this.sN7,
      this.dWS});

  FolderConfig.fromJson(Map<String, dynamic> json) {
    sN1 = json['SN1'].cast<dynamic>();
    sN2 = json['SN2'].cast<dynamic>();
    sN3 = json['SN3'].cast<dynamic>();
    sN4 = json['SN4'].cast<dynamic>();
    sN5 = json['SN5'].cast<dynamic>();
    sN6 = json['SN6'].cast<dynamic>();
    sN7 = json['SN7'].cast<dynamic>();
    dWS = json['DWS'].cast<dynamic>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SN1'] = this.sN1;
    data['SN2'] = this.sN2;
    data['SN3'] = this.sN3;
    data['SN4'] = this.sN4;
    data['SN5'] = this.sN5;
    data['SN6'] = this.sN6;
    data['SN7'] = this.sN7;
    data['DWS'] = this.dWS;
    return data;
  }
}

class FileData {
  String types;
  List<dynamic> data;

  FileData({
    required this.types,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      types: data,
    };
  }

  factory FileData.fromJson(String types, List<dynamic> json) {
    return FileData(types: types, data: json);
  }
}

List<FileData> fetchString(Map<String, dynamic> Data) {
  List<FileData> timeDataList = [];

  Data.forEach((key, value) {
    timeDataList.add(FileData.fromJson(key, value));
  });

  return timeDataList;
}
