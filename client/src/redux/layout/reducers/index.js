import layout from './layout';
// import { routerReducer } from 'react-router-redux';
import { createResponsiveStateReducer } from 'redux-responsive';
import browserStateExtension from './browserStateExtension';
// import { location } from '../../location/reducers';

const browserReducer = createResponsiveStateReducer({
  // overrides are set using max values for breakpoints
  extraSmall: 767,
  small: 991,
  medium: 1199,
  large: 1499,
  extraLarge: 5000, // unrealistic res-size, used to prevent "mediaType:'infinity'"
});

const browser = (state, action) => {
  // daisy-chaining the responsive-state reducer into our custom one so we can extend it's state
  const newState = browserReducer(state, action);
  return browserStateExtension(newState, action);
};

// const routing = (state, action) => {
//   const newState = location(state, action);
//   return routerReducer(newState, action);
// };

export { browser, layout };
