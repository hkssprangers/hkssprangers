package hkssprangers.browser.forms;

import hkssprangers.info.Shop;
import js.lib.Object;
import mui.core.*;
import mui.core.styles.Styles;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;

typedef OrderObjectFieldTemplateProps = js.npm.rjsf.material_ui.ObjectFieldTemplate.ObjectFieldTemplateProps;

class OrderObjectFieldTemplate extends ReactComponentOf<OrderObjectFieldTemplateProps, Dynamic> {
    function isShopSelected():Bool {
        if (props.formData == null)
            return false;

        var shop:Shop = props.formData.shop;
        return shop != null;
    }
    override function render():ReactFragment {
        var props:OrderObjectFieldTemplateProps = cast Object.assign({}, props, {
            properties: [
                for (p in props.properties)
                if (!(p.name == "shop" && isShopSelected()))
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