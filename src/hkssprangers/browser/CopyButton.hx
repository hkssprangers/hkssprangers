package hkssprangers.browser;

import mui.core.*;
import js.Browser.*;
import js.lib.Promise;
import haxe.Timer;

typedef CopyButtonProps = {
    final text:()->Promise<String>;
};

typedef CopyButtonState = {
    final openMessage:Bool;
}

class CopyButton extends ReactComponentOf<CopyButtonProps, CopyButtonState> {
    function new(props) {
        super(props);
        state = {
            openMessage: false,
        };
    }

    function onClickCopy():Void {
        props.text().then(text -> {
            CopyToClipboard.call(text, {
                format: "text/plain",
                onCopy: function (d) {
                    setState({
                        openMessage: true,
                    });
                    Timer.delay(() -> setState({ openMessage: false }), 4000);
                },
            });
        });
    }

    override function render():ReactFragment {
        return jsx('
            <Tooltip
                title="成功複製"
                arrow
                open=${state.openMessage}
                disableFocusListener
                disableHoverListener
                disableTouchListener
            >
                <IconButton onClick=${onClickCopy}>
                    <i className="far fa-clipboard"></i>
                </IconButton>
            </Tooltip>
        ');
    }
}