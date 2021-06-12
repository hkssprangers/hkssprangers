package hkssprangers.browser.forms;

import js.lib.Object;
import mui.core.*;
import js.npm.rjsf.material_ui.*;
using Reflect;
using Lambda;

typedef OrderItemArrayFieldTemplateProps = {
    final schema:Dynamic;
    final formData:Array<Dynamic>;
    final items:Array<Dynamic>;
    final idSchema:Dynamic;
    final TitleField:Dynamic;
    final DescriptionField:Dynamic;
    final title:Null<String>;
    final description:Null<String>;
    final required:Bool;
    final readonly:Bool;
    final canAdd:Bool;
    final disabled:Bool;
    final onAddClick:Dynamic;
}

class OrderItemArrayFieldTemplate extends ReactComponentOf<OrderItemArrayFieldTemplateProps, Dynamic> {
    static function dollarId(o:Dynamic) return Reflect.field(o, "$id");

    static function DefaultArrayItem(props) {
        var toolbar = if (props.hasToolbar) {
            var moveUp = if (props.hasMoveUp || props.hasMoveDown) {
                jsx('
                    <IconButton
                        disabled=${props.disabled || props.readonly || !props.hasMoveUp}
                        onClick=${props.onReorderClick(props.index, props.index - 1)}
                    >
                        <i className="fas fa-chevron-up text-sm"></i>
                    </IconButton>
                ');
            } else null;
            var moveDown = if (props.hasMoveUp || props.hasMoveDown) {
                jsx('
                    <IconButton
                        disabled=${props.disabled || props.readonly || !props.hasMoveDown}
                        onClick=${props.onReorderClick(props.index, props.index + 1)}
                    >
                        <i className="fas fa-chevron-down text-sm"></i>
                    </IconButton>
                ');
            } else null;
            var remove = if (props.hasRemove) {
                jsx('
                    <IconButton
                        disabled=${props.disabled || props.readonly}
                        onClick=${props.onDropIndexClick(props.index)}
                    >
                        <i className="fas fa-trash text-red-500 text-sm"></i>
                    </IconButton>
                ');
            } else null;
            jsx('
                <div className="flex-none">
                    ${moveUp}
                    ${moveDown}
                    ${remove}
                </div>
            ');
        } else null;
        return jsx('
            <div className="flex w-full items-center mb-2">
                <div className="flex-grow">
                    ${props.children}
                </div>
                ${toolbar}
            </div>
        ');
    }

    override function render():ReactFragment {
        var TitleField = props.TitleField;
        var title = switch (props.title) {
            case null:
                null;
            case title:
                jsx('
                    <TitleField
                        id=${'${dollarId(props.idSchema)}-title'}
                        title=${title}
                        required=${props.required}
                    />
                ');
        };
        var DescriptionField = props.DescriptionField;
        var description = switch (props.description) {
            case null:
                props.schema.description;
            case v:
                v;
        };
        var description = jsx('
            <DescriptionField
                id=${'${dollarId(props.idSchema)}-description'}
                description=${description}
            />
        ');
        var items = if (props.items != null)
            props.items.map(DefaultArrayItem);
        else
            null;
        var addButton = if (props.canAdd) {
            jsx('
                <Button
                    variant=${Outlined}
                    className="array-item-add"
                    color=${Primary}
                    onClick=${props.onAddClick}
                    disabled=${props.disabled || props.readonly}
                >
                    <i className="fas fa-plus"></i>
                </Button>
            ');
        } else null;
        return jsx('
            <Fragment>
                ${title}
                ${description}
        
                <Grid container key=${'array-item-list-${dollarId(props.idSchema)}'}>
                    ${items}
                    ${addButton}
                </Grid>
            </Fragment>
        ');
    }
}