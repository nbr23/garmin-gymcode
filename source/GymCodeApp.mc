using Toybox.Application;
using Toybox.WatchUi;

class GymCodeApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [new GymCodeView(), new GymCodeDelegate()];
    }

    (:glance)
    function getGlanceView() {
        return [new GymCodeGlanceView()];
    }
}
