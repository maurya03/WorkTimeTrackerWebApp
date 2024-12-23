// Sanatize dynamic parameters
export const _sanParam = param => (!param ? { default: { App: null, init: null } } : param);

export const _dynamicLoad = ({
  store,
  nextState,
  cb,
  main: { default: { App: main, init: mainInit } },
  left: { default: { App: left, init: leftInit } },
  bottom: { default: { App: bottom, init: bottomInit } },
  onInit,
}) => {
  if (onInit) {
    onInit(store);
  }

  if (leftInit) {
    leftInit(store, nextState);
  }

  if (bottomInit) {
    bottomInit(store, nextState);
  }

  if (mainInit) {
    mainInit(store, nextState);
  }

  if (!left || store.getState().routing.isFullScreenMode ||
      (store.getState().routing.locationBeforeTransitions.search).indexOf('fullscreen=true') !== -1) {
    cb(null, { fullscreen: main });
  } else {
    cb(null, { main, left, bottom });
  }
};

const loader = store =>
  ({ nextState, cb, main, left, bottom, onInit }) =>
    _dynamicLoad({
      store,
      nextState,
      cb,
      main: _sanParam(main ? main(store) : main),
      left: _sanParam(left ? left(store) : left),
      bottom: _sanParam(bottom ? bottom(store) : bottom),
      onInit,
    });

export default loader;
