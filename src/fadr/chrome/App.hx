package fadr.chrome;

import js.Browser.document;
import js.Browser.window;
import haxe.Timer;

class App extends fadr.App {

    override function init() {

        super.init();

        chrome.Storage.onChanged.addListener(function(changes,namespace){

            if( changes.changeInterval != null ) {
                view.changeInterval = menu.changeInterval.value = changes.changeInterval.newValue;
            }
            if( changes.fadeDuration != null ) {
                view.fadeDuration = menu.fadeDuration.value = changes.fadeDuration.newValue;
            }
            if( changes.brightness != null ) {
                view.brightness = menu.brightness.value = changes.brightness.newValue;
            }
            if( changes.saturation != null ) {
                view.saturation = menu.saturation.value = changes.saturation.newValue;
            }

            if( changes.powerLevel != null ) {
                if( changes.powerLevel.newValue == null ) {
                    menu.powerLevel.unselect( changes.powerLevel.oldValue );
                    chrome.Power.releaseKeepAwake();
                } else {
                    menu.powerLevel.select( changes.powerLevel.newValue );
                    chrome.Power.requestKeepAwake( changes.powerLevel.newValue );
                }
            }
            /*
            if( changes.idleTimeout != null ) {
                menu.idleTimeout.value = changes.idleTimeout.newValue;
                chrome.Idle.setDetectionInterval( changes.idleTimeout.newValue );
            }
            */
        });
    }

    function close() {
        chrome.Runtime.getBackgroundPage(function(win:js.html.Window){
            untyped win.Fadr.stopScreensaver();
        });
    }

    override function handleContextMenu(e) {
        super.handleContextMenu(e);
        menu.isVisible ? menu.hide() : close();
    }

    static function main() {
        window.onload = function(_){
            chrome.Storage.local.get( {
                    brightness: 100,
                    saturation: 100,
                    fadeDuration: 1000,
                    changeInterval: 2000,
                    //screensaver: false, //TODO
                    //idleTimeout: 600,
                    powerLevel: null,
                },
                function(settings:SettingsData){
                    var app = new App( settings );
                    Timer.delay( app.init, 1 );
                }
            );
        }
    }
}
