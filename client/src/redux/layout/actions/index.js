import * as types from "rootpath/redux/common/constants/ActionTypes";

export const initLayout = () => ({
    type: types.ON_INIT
});

export const toggleFullscreen = () => ({
    type: types.TOGGLE_DESKTOP
});
