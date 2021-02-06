package hkssprangers.browser.forms;

import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;

typedef OrderItemTemplateProps = Dynamic;

class OrderItemTemplate extends ReactComponentOf<OrderItemTemplateProps, Dynamic> {
    override function render():ReactFragment {
        var errors = if (props.rawErrors != null && props.rawErrors.length > 0) {
            var items = props.rawErrors.map((error, i:Int) -> {
                return jsx('
                    <ListItem key=${i} disableGutters>
                        <FormHelperText>${error}</FormHelperText>
                    </ListItem>
                ');
            });
            jsx('
                <List dense disablePadding>
                    ${items}
                </List>
            ');
        } else {
            null;
        }
        return jsx('
            <FormControl
                id=${props.id}
                fullWidth
                error=${props.rawErrors != null && props.rawErrors.length > 0}
                required=${props.required}>
                ${props.children}
                ${errors}
            </FormControl>
        ');
    }
}