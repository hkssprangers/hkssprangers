package hkssprangers.browser.forms;

import js.lib.Object;
import hkssprangers.info.Shop;
import hkssprangers.info.Order;
import hkssprangers.info.TimeSlot;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrderFieldFormData = {
    final shop:Shop;
}

typedef OrderFieldProps = {
    final schema:Dynamic;
    final uiSchema:Dynamic;
    final formData:OrderFieldFormData;
    function onChange(v:Dynamic):Void;
};

typedef OrderFieldState = {}

class OrderField extends ReactComponentOf<OrderFieldProps, Dynamic> {
    final schema:Dynamic;
    final uiSchema:Dynamic;

    function new(props, context):Void {
        super(props, context);

        schema = {
            type: "object",
            properties: {
                shop: {
                    type: "string",
                    title: "店舖",
                    oneOf: Shop.all.map(s -> {
                        type: "string",
                        title: s.info().name,
                        const: s,
                    }),
                }, 
            }
        }
        uiSchema = {

        }
    }

    function shopOnChange(e:{
        edit:Bool,
        formData:OrderFieldFormData,
        errors:Array<Dynamic>,
        errorSchema:Dynamic,
        idSchema:Dynamic,
        schema:Dynamic,
        uiSchema:Dynamic,
        ?status:String,
    }) {
        props.onChange(e.formData);
    }

    function orderOnChange(e:{
        edit:Bool,
        formData:OrderFieldFormData,
        errors:Array<Dynamic>,
        errorSchema:Dynamic,
        idSchema:Dynamic,
        schema:Dynamic,
        uiSchema:Dynamic,
        ?status:String,
    }) {
        props.onChange(Object.assign({}, {
            shop: props.formData.shop,
        }, e.formData));
    }

    override function render():ReactFragment {
        trace(props.schema);
        var orderForm = if (props.formData.shop == null) {
            null;
        } else switch (props.formData.shop) {
            case EightyNine:
                // jsx('<EightyNineForm />');
                null;
            case DongDong:
                jsx('
                    <DongDongForm
                        schema=${props.schema}
                        formData=${props.formData}
                        onChange=${orderOnChange}
                    />
                ');
            case _:
                null;
        }
        return jsx('
            <div>
                <Form
                    tagName="div"
                    schema=${schema}
                    uiSchema=${uiSchema}
                    formData=${props.formData}
                    onChange=${shopOnChange}
                    children=${[]}
                />
                ${orderForm}
            </div>
        ');
    }
}