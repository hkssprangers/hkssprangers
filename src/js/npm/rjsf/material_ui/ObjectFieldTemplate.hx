package js.npm.rjsf.material_ui;

import react.ReactComponent;

typedef ObjectFieldTemplateProps = {
    final DescriptionField:Dynamic;
    final description:String;
    final TitleField:Dynamic;
    final title:String;
    final properties:Array<{
        content:ReactElement,
        name:String,
        disabled:Bool,
        readonly:Bool,
    }>;
    final required:Bool;
    final disabled:Bool;
    final readonly:Bool;
    final uiSchema:Dynamic;
    final idSchema:Dynamic;
    final schema:Dynamic;
    final formData:Dynamic;
    final onAddClick:Dynamic;
};

@:jsRequire("@rjsf/material-ui", "ObjectFieldTemplate")
extern class ObjectFieldTemplate extends ReactComponentOf<ObjectFieldTemplateProps, Dynamic> {

}