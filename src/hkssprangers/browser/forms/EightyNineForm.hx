package hkssprangers.browser.forms;

import js.npm.rjsf.material_ui.Form;
import mui.core.*;

class EightyNineForm extends ReactComponentOf<Dynamic, Dynamic> {
    final schema = {
        type: "string",
    };

    function onSubmit(r:{formData:Dynamic}, e:ReactEvent) {

    }

    override function render():ReactFragment {
        return jsx('
            <Card>
                <Form schema=${schema} onSubmit=${onSubmit}>
                </Form>
            </Card>
        ');
    }
}