package js.npm.aws_sdk;

import js.lib.Promise;
import haxe.Constraints;

@:jsRequire("aws-sdk", "S3")
extern class S3 {
    public function new(?options:Dynamic):Void;
    public function upload(?params:Dynamic, ?options:Dynamic, ?callback:Dynamic):ManagedUpload;
    public function getSignedUrlPromise(operation:String, params:Dynamic):Promise<String>;
}

@:jsRequire("aws-sdk", "S3.ManagedUpload")
extern class ManagedUpload {
    public function new(?options:Dynamic):Void;
    public function abort():Void;
    public function promise():Promise<Dynamic>;
    public function send(callback:Function):Void;
}