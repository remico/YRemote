using Toybox.WatchUi;
using Toybox.Communications;

class RestDelegate extends WatchUi.BehaviorDelegate {
    var notify;

    // Set up the callback to the view
    function initialize(handler) {
        BehaviorDelegate.initialize();
        notify = handler;
    }

    function onKeyPressed(evt) {
        if( evt.getKey() == KEY_ENTER) {
            System.println("KEY_ENTER pressed");
//            makeRequest();
        }
        return true;
    }

    function onSelect() {
        System.println("onSelect() called");
        makeRequest();
        return true;
    }

    function makeRequest() {
        notify.invoke("Executing\nRequest");

        var params = {
        };

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        Communications.makeWebRequest(
            "https://jsonplaceholder.typicode.com/todos/113",
            params,
            options,
            method(:onReceive)
        );
    }

    // Receive the data from the web request
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
            notify.invoke(data);
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}