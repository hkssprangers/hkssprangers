package hkssprangers;

enum abstract DeployStage(String) from String {
    var dev;
    var master;
    var production;
}