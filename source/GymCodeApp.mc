using Toybox.Application;
using Toybox.WatchUi;

class GymCodeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var view = new GymCodeView();
        return [view, new GymCodeDelegate(view)];
    }

    (:glance)
    function getGlanceView() {
        return [new GymCodeGlanceView()];
    }
}
