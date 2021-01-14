using Toybox.WatchUi;
using Toybox.Attention;

class ButtonDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
//        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        if( Attention has :vibrate) {
            var vibrateData = [ new Attention.VibeProfile(  25, 100 ),
                    new Attention.VibeProfile(  25, 100 ),
                    // new Attention.VibeProfile(  75, 100 ),
                    // new Attention.VibeProfile( 100, 100 ),
                    // new Attention.VibeProfile(  75, 100 ),
                    // new Attention.VibeProfile(  50, 100 ),
                    // new Attention.VibeProfile(  25, 100 )
                    ];

            Attention.vibrate( vibrateData );
        }
        return true;
    }

    function onMenu() {
        if( Attention has :vibrate) {
            var vibrateData = [ new Attention.VibeProfile(  25, 100 ),
                    // new Attention.VibeProfile(  50, 100 ),
                    // new Attention.VibeProfile(  75, 100 ),
                    // new Attention.VibeProfile( 100, 100 ),
                    // new Attention.VibeProfile(  75, 100 ),
                    // new Attention.VibeProfile(  50, 100 ),
                    // new Attention.VibeProfile(  25, 100 )
                    ];

            Attention.vibrate( vibrateData );
        }
        return true;
    }
}
