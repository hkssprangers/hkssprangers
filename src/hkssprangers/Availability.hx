package hkssprangers;

enum Availability {
    Available;
    Unavailable(reason:String);
}