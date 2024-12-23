const initialState = {
    desktopVisiblePanel: 'both',
    deviceVisiblePanel: 'left',
    leftArea: '',
    mainArea: '',
  };

  const layout = (state = initialState, action) => {
    switch (action.type) {
      case 'LAYOUT_DESKTOP_TOGGLE_FULLSCREEN':
        return {
          ...state,
          desktopVisiblePanel: state.desktopVisiblePanel === 'both' ? 'right' : 'both',
        };
        default:
      return state;
  }
};

export default layout;
