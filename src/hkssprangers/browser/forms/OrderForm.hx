package hkssprangers.browser.forms;

import hkssprangers.info.Shop;
import js.npm.rjsf.material_ui.*;
import mui.core.*;
using hkssprangers.info.TimeSlotTools;

typedef OrderFormProps = {
    final shop:Shop;
    final schema:Dynamic;
    final uiSchema:Dynamic;
    function onSubmit(r:{formData:Dynamic}, e:ReactEvent):Void;
}

class OrderForm extends ReactComponentOf<OrderFormProps, Dynamic> {
    override function render():ReactFragment {
        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    ${props.shop.info().name} x 埗兵 外賣表格
                </h1>
                <p className="text-sm text-gray-500">*必填項目</p>
                <Form
                    schema=${props.schema}
                    uiSchema=${props.uiSchema}
                    onSubmit=${props.onSubmit}
                >
                </Form>
            </div>
        ');
    }
}