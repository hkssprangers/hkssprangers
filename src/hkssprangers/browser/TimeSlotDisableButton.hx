package hkssprangers.browser;

import mui.core.*;
import js.Browser.*;
import js.html.*;
import js.lib.Promise;
import haxe.Timer;
import hkssprangers.info.TimeSlot;
using StringTools;

typedef TimeSlotDisableButtonProps = {
    final timeSlot:TimeSlot;
    final initDisabled:Bool;
};

typedef TimeSlotDisableButtonState = {
    final isLoading:Bool;
    final disabled:Bool;
}

class TimeSlotDisableButton extends ReactComponentOf<TimeSlotDisableButtonProps, TimeSlotDisableButtonState> {
    static public final disableMessage = "暫停接單";
    final stopIcon = jsx('<i className="fa-solid fa-ban opacity-75"></i>');
    final stopIconChecked = jsx('<i className="fa-solid fa-ban text-red-600"></i>');

    function new(props) {
        super(props);
        state = {
            isLoading: false,
            disabled: props.initDisabled,
        };
    }

    function onChange(evt:Event) {
        setState({
            isLoading: true,
        });
        final checked:Bool = (untyped evt.target).checked;
        final availability:Null<Availability> = switch (checked) {
            case true: Unavailable(disableMessage);
            case false: null;
        };
        window.fetch("/admin", {
            method: "post",
            headers: {
                "Content-Type": "application/json",
            },
            body: tink.Json.stringify({
                action: "set-time-slot",
                timeSlot: props.timeSlot,
                availability: availability,
            }),
        })
            .then(r ->
                if (r.redirected && new URL(r.url).pathname.startsWith("/login")) {
                    location.assign("/login?" + new URLSearchParams({
                        redirectTo: location.pathname + location.search,
                    }));
                } else if (!r.ok) {
                    setState({
                        isLoading: false,
                    });
                    r.text().then(text -> window.alert(text));
                } else {
                    setState({
                        isLoading: false,
                        disabled: checked,
                    });
                }
            );
    }

    override function render():ReactFragment {
        return jsx('
            <Checkbox
                icon=${stopIcon}
                checkedIcon=${stopIconChecked}
                checked=${state.disabled}
                onChange=${onChange}
            />
        ');
    }
}