using Toybox.WatchUi;

class WatchRemoteView extends WatchUi.View {
    hidden var mStateDefault = false;
    hidden var mMessage = "Touch the screen";

    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        if (mStateDefault) {
            setLayout(Rez.Layouts.ButtonLayoutDefault(dc));
        } else {
            setLayout(Rez.Layouts.ButtonLayoutRecording(dc));
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);  // Call the parent onUpdate function to redraw the layout - draw default monkey picture

//        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
//        dc.clear();
//        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onReceive(args) {
        if (args instanceof Lang.String) {
            mMessage = args;
        }
        else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            mMessage = "";
            for( var i = 0; i < keys.size(); i++ ) {
                mMessage += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }
}
