package hkssprangers.browser.forms;

import haxe.Json;
import hkssprangers.info.TimeSlot;
import js.lib.Object;
import hkssprangers.info.Shop;
import js.npm.rjsf.material_ui.*;
import mui.core.*;
using hkssprangers.info.TimeSlotTools;
using Reflect;

typedef OrderFormProps = {}
typedef OrderFormState = {
    final formData:OrderFormData;
}

typedef OrderFormData = {
    ?pickupTimeSlot:String,
    ?orders:Array<OrderData>,
}

typedef OrderData = {
    ?shop:Shop,
    ?items:Array<Dynamic>,
}

class OrderForm extends ReactComponentOf<OrderFormProps, OrderFormState> {
    final nextSlots = TimeSlotTools.nextTimeSlots(Date.now());
    static public function selectedPickupTimeSlot(formData:OrderFormData):TimeSlot {
        return switch (formData.pickupTimeSlot) {
            case null: null;
            case str: Json.parse(str);
        };
    }
    static public function getSchema(nextSlots:Array<TimeSlot>, formData:OrderFormData) {
        var pickupTimeSlot = selectedPickupTimeSlot(formData);
        var shopSchema = {
            type: "string",
            title: "店舖",
            oneOf: Shop.all.map(s -> {
                type: "string",
                title: s.info().name,
                const: s,
            }),
        };
        function orderSchema() return {
            type: "object",
            properties: {
                shop: shopSchema,
            },
            required: [
                "shop",
            ],
        };
        var schema = {
            type: "object",
            properties: {
                pickupTimeSlot: {
                    type: "string",
                    title: "想幾時收到?",
                    oneOf: nextSlots.map(s -> {
                        title: s.print(),
                        const: Json.stringify(s),
                    }),
                },
                orders: {
                    type: "array",
                    items: formData.orders == null ? [] : formData.orders.map(o -> {
                        var orderSchema = orderSchema();
                        switch (o.shop) {
                            case null:
                                //pass
                            case DongDong:
                                Object.assign(orderSchema.properties, {
                                    shop: shopSchema,
                                    items: {
                                        if (pickupTimeSlot == null) {
                                            {
                                                type: "array",
                                                items: {
                                                    type: "object",
                                                }
                                            };
                                        } else {
                                            DongDongForm.itemsSchema(pickupTimeSlot, o);
                                        }
                                    },
                                });
                            case _:
                                //pass
                        }
                        orderSchema;
                    }),
                    additionalItems: orderSchema(),
                    minItems: 1,
                }
            },
            required: [
                "pickupTimeSlot",
                "orders",
            ],
            definitions: Object.assign(
                {},
                DongDongForm.schemaDefinitions
            ),
        };
        return schema;
    }

    function new(props, context):Void {
        super(props, context);
        state = {
            formData: {},
        };
    }

    function getUiSchema(formData:OrderFormData) {
        var pickupTimeSlot = selectedPickupTimeSlot(formData);
        return {
            orders: {
                "ui:ArrayFieldTemplate": OrdersTemplate,
                items:{
                    shop: {
                        "ui:widget": ShopSelectorWidget,
                        "ui:options": {
                            pickupTimeSlot: pickupTimeSlot,
                        },
                    },
                    items: {
                        "ui:ArrayFieldTemplate": OrderItemsTemplate,
                        items: {
                            "ui:FieldTemplate": OrderItemTemplate,
                            item: {
                                "ui:FieldTemplate": OrderItemTemplate,
                            },
                        },
                    }
                }
            },
        };
    }

    override function render():ReactFragment {
        var schema = getSchema(nextSlots, state.formData);
        var uiSchema = getUiSchema(state.formData);

        function onChange(e:{
            edit:Bool,
            formData:OrderFormData,
            errors:Array<Dynamic>,
            errorSchema:Dynamic,
            idSchema:Dynamic,
            schema:Dynamic,
            uiSchema:Dynamic,
            ?status:String,
        }) {
            // trace(e.formData);
            // Ajv.call({
            //     removeAdditional: "all"
            // }).compile(schema).call(e.formData);
            // trace(e.formData);
            setState({
                formData: e.formData,
            });
        }

        function onSubmit(e:{
            formData:OrderFormData,
        }, _) {
            var isValid:Bool = Ajv.call({
                removeAdditional: "all",
            }).compile(schema).call(e.formData);
            trace(isValid);
            trace(Json.stringify(e.formData, null, "  "));
        }

        function validate(formData:OrderFormData, errors:Dynamic):Dynamic {
            var t = selectedPickupTimeSlot(formData);
            for (i => o in formData.orders) {
                if (o.shop != null) {
                    switch o.shop.checkAvailability(t) {
                        case Available:
                            //pass
                        case Unavailable(reason):
                            errors.orders[i].addError(reason);
                    }
                }
            }
            return errors;
        }
        
        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    埗兵外賣表格
                </h1>
                <p className="text-sm text-gray-500">*必填項目</p>
                <Form
                    key=${Json.stringify({
                        schema: schema,
                        uiSchema: uiSchema,
                    })}
                    schema=${schema}
                    uiSchema=${uiSchema}
                    formData=${state.formData}
                    onChange=${onChange}
                    onSubmit=${onSubmit}
                    validate=${validate}
                >
                </Form>
                <pre>${haxe.Json.stringify(state.formData, null, "  ")}</pre>
            </div>
        ');
    }
}