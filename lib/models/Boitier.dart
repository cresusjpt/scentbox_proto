import 'package:floor/floor.dart';

@entity
class Boitier {

  @PrimaryKey(autoGenerate: true)
  int id;
  String uniqueid;
  String label;
  String password;
  String parfum;
  bool state;
  int remoteSettings;
  int intensite;
  bool manuel;
  int remoteid;
  int mode = 0;

  Boitier(
      {this.id,
      this.uniqueid,
      this.label,
      this.password,
      this.parfum,
      this.state,
      this.remoteSettings,
      this.intensite,
      this.manuel,
      this.remoteid,
      this.mode});


  int getCommandeIntensite(){
    int ret = 0;
    switch(this.intensite){
      case 0:
        ret = 70;
        break;
      case 20:
        ret = 107;
        break;
      case 40:
        ret = 144;
        break;
      case 60:
        ret = 181;
        break;
      case 80:
        ret = 218;
        break;
      case 100:
        ret = 255;
        break;
    }

    return ret;
  }
}
