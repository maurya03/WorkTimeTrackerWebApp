import { combineReducers } from 'redux';
import layout from './layout';
import common from './common';
import timesheet from './timesheet';
export const createReducer = () =>
  combineReducers({
    ...layout.Reducers,
    ...common.Reducers,
    ...timesheet.Reducers
  });
