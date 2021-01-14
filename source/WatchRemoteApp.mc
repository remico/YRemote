using Toybox.Application;

class WatchRemoteApp extends Application.AppBase {
    hidden var mView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new WatchRemoteView();
        return [ mView , new ButtonDelegate() ];
//        return [ mView , new RestDelegate(mView.method(:onReceive)) ];
    }

}