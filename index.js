'use strict';

import { DeviceEventEmitter, NativeModules, Platform } from 'react-native';
var vctrl = NativeModules.VolumeControl;

class VolumeControl {

    getVolumeValue(callback) {
        vctrl.getVolumeValue(ret => {
            callback(ret)
        })
    }

    setVolumeValue(value) {
        vctrl.setVolumeValue(value)
    }

}

module.exports = VolumeControl;
