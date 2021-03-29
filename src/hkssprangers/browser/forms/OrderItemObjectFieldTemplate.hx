package hkssprangers.browser.forms;

import js.lib.Object;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;

typedef OrderItemObjectFieldTemplateProps = js.npm.rjsf.material_ui.ObjectFieldTemplate.ObjectFieldTemplateProps;

class OrderItemObjectFieldTemplate extends ReactComponentOf<OrderItemObjectFieldTemplateProps, Dynamic> {
    function isTypeValid():Bool {
        if (props.formData == null || props.formData.type == null)
            return false;

        var type:String = props.formData.type;
        var typeOptions:Array<{const:String}> = props.schema.properties.type.oneOf;
        return typeOptions.exists(opt -> opt.const == type);
    }

    override function render():ReactFragment {
        if (props.formData != null && props.formData.type != null && !isTypeValid()) {
            return jsx('
                <div>
                    ⚠️ 請移除此項目。
                </div>
            ');
        }
        var props:OrderItemObjectFieldTemplateProps = cast Object.assign({}, props, {
            properties: [
                for (p in props.properties)
                if (!(p.name == "type" && isTypeValid()))
                p
            ],
        });
        var id = Reflect.field(props.idSchema, "$id");
        var TitleField = props.TitleField;
        var title = switch (props.title) {
            case null:
                null;
            case title:
                jsx('
                    <TitleField
                        id=${'${id}-title'}
                        title=${title}
                        required=${props.required}
                    />
                ');
        };
        var DescriptionField = props.DescriptionField;
        var description = switch (props.description) {
            case null:
                null;
            case description:
                jsx('
                    <DescriptionField
                        id=${'${id}-description'}
                        description=${description}
                    />
                ');
        };
        var properties = props.properties.mapi((index, p) -> {
            jsx('
                <Grid
                    item
                    xs=${12}
                    key=${index}
                    style=${{ marginBottom: '10px' }}
                >
                    ${p.content}
                </Grid>
            ');
        });
        return jsx('
            <Fragment>
                ${title}
                ${description}
                <Grid container spacing=${Spacing_2}>
                    ${properties}
                </Grid>
            </Fragment>
        ');
    }
}