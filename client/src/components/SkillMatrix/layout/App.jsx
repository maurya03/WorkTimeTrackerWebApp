import './layout.less';
import PropTypes from 'prop-types';
import React from 'react';
import LeftPanel from './LeftPanel';
import RightPanel from './RightPanel';
import BottomPanel from './BottomPanel';

const App = ({
  left,
  main,
  bottom,
  fullscreen,
  isDesktopLayout,
  desktopVisiblePanel,
  deviceVisiblePanel,
  isLoggedIn,
  pathName
}) => {
  if (isLoggedIn === false && pathName !== 'login') {
    return null;
  }
  if (fullscreen) {
    return <div className="full-height">{fullscreen}</div>;
  }

  // Let the left/right panels decide how they will render when supposed to be hidden.
  // If we instead didn't render the panels, user will lose context on toggling areas.

  return (
    <div className="full-height">
      Dhiraj Kumar
      <div
        className={`${
          bottom && isDesktopLayout ? 'bottomVisible' : null
        } main row`}
      >
        <LeftPanel
          content={left}
          isDesktopLayout={isDesktopLayout}
          desktopVisiblePanel={desktopVisiblePanel}
          deviceVisiblePanel={deviceVisiblePanel}
        />
        <RightPanel
          content={main}
          isDesktopLayout={isDesktopLayout}
          desktopVisiblePanel={desktopVisiblePanel}
          deviceVisiblePanel={deviceVisiblePanel}
        />
      </div>
      {bottom ? <BottomPanel content={bottom} /> : null}
    </div>
  );
};

App.propTypes = {
  fullscreen: PropTypes.element,
  main: PropTypes.element,
  left: PropTypes.element,
  bottom: PropTypes.element,
  isDesktopLayout: PropTypes.bool.isRequired,
  deviceVisiblePanel: PropTypes.string.isRequired,
  desktopVisiblePanel: PropTypes.string.isRequired
};

export default App;
