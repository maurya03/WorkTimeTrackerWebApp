import { applyMiddleware, compose, createStore } from 'redux';
import thunk from 'redux-thunk';
import { responsiveStoreEnhancer } from 'redux-responsive';
import { composeWithDevTools } from 'redux-devtools-extension';

// devtools for debugging in dev environment.
// const devTools =
//   // eslint-disable-next-line no-undef
//   process.env.NODE_ENV !== 'production' && window.__REDUX_DEVTOOLS_EXTENSION__
//     ? window.__REDUX_DEVTOOLS_EXTENSION__ &&
//       window.__REDUX_DEVTOOLS_EXTENSION__()
//     : a => a;

export default function configureStoreBase(createReducer) {
  const store = createStore(
    createReducer(),
    compose(
      responsiveStoreEnhancer,
      composeWithDevTools(applyMiddleware(thunk))
    )
  );
  return store;
}
