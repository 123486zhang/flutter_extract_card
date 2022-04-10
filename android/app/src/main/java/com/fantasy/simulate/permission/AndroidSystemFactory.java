package com.fantasy.simulate.permission;


import com.fantasy.simulate.permission.platform.AndroidSystem;
import com.fantasy.simulate.permission.platform.iml.AbstractAndroidSystem;
import com.fantasy.simulate.permission.platform.iml.HuaweiSystem;
import com.fantasy.simulate.permission.platform.iml.MeizuSystem;
import com.fantasy.simulate.permission.platform.iml.MiSystem;
import com.fantasy.simulate.permission.platform.iml.OppoSystem;
import com.fantasy.simulate.permission.platform.iml.QiHooSystem;
import com.fantasy.simulate.permission.platform.iml.VivoSystem;
import com.fantasy.simulate.utils.RomUtils;

/**
 * Created by spark on 2018/4/24.
 */

public class AndroidSystemFactory {

    /**
     * 根据Android系统制造商名字,获取到平台
     *
     * @return 对应的Android操作平台
     */
    public static AndroidSystem findAndroidSystem() {
        AndroidSystem androidSystem;
        if (RomUtils.checkIsOppoRom()) {
            androidSystem = new OppoSystem();
        } else if (RomUtils.checkIsMiuiRom()) {
            androidSystem = new MiSystem();
        } else if (RomUtils.checkIsMeizuRom()) {
            androidSystem = new MeizuSystem();
        } else if (RomUtils.checkIsHuaweiRom()) {
            androidSystem = new HuaweiSystem();
        } else if (RomUtils.checkIs360Rom()) {
            androidSystem = new QiHooSystem();
        } else if (RomUtils.checkIsVivoRom()) {
            androidSystem = new VivoSystem();
        } else {
            androidSystem = new AbstractAndroidSystem() {
            };
        }
        return androidSystem;
    }
}
