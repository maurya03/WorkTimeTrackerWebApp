import configureStoreBase from './index';
import { createReducer } from '../redux/index.redux';

export default function configureStore() {
  return configureStoreBase(createReducer);
}
