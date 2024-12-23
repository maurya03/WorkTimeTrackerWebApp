const browserStateExtension = (state = {}, action) => {
  switch (action.type) {
    case 'redux-responsive/CALCULATE_RESPONSIVE_STATE':
      return Object.assign({}, state, {
        screenLayout: (state.mediaType === 'extraSmall' || state.mediaType === 'small')
          ? 'device' : 'desktop',
        width: action.innerWidth,
        height: action.innerHeight,
        // drawersVisible: (state.mediaType === 'large' || state.mediaType === 'extraLarge'),
      });
    default:
      return state;
  }
};

export default browserStateExtension;
