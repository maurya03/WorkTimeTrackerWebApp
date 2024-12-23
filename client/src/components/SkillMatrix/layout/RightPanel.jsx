import PropTypes from 'prop-types';
import React from 'react';

const RightPanel = ({
  content,
  isDesktopLayout,
  desktopVisiblePanel,
  deviceVisiblePanel
}) => {
  let classNames = 'appPanel';

  if (isDesktopLayout) {
    if (desktopVisiblePanel === 'both') {
      classNames += ' col-md-9';
    } else {
      classNames += ' col-sm-12';
    }
  } else {
    // eslint-disable-next-line no-lonely-if
    if (deviceVisiblePanel === 'left') {
      classNames += ' noShow';
    } else {
      classNames += ' col-sm-12';
    }
  }

  return <div className={classNames}>{content}</div>;
};

RightPanel.propTypes = {
  content: PropTypes.element,
  isDesktopLayout: PropTypes.bool.isRequired,
  desktopVisiblePanel: PropTypes.string.isRequired,
  deviceVisiblePanel: PropTypes.string.isRequired
};

export default RightPanel;
