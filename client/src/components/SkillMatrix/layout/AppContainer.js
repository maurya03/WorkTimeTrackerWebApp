import { connect } from 'react-redux';
import App from './App';
import { toggleFullscreen } from 'rootpath/redux/layout/actions';

const mapStateToProps = state => ({
  isDesktopLayout: true,
  desktopVisiblePanel: state.layout.desktopVisiblePanel,
  deviceVisiblePanel: state.layout.deviceVisiblePanel
});

const mapDispatchToprops = dispatch => ({
  onDesktopToggleFullscreen: () => {
    dispatch(toggleFullscreen());
  }
});

const AppContainer = connect(mapStateToProps, mapDispatchToprops)(App);

export default AppContainer;
