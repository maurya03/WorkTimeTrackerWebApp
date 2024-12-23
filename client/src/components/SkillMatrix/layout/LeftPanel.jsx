import PropTypes from 'prop-types';
import React from 'react';

const LeftPanel = ({
  content,
  isDesktopLayout,
  desktopVisiblePanel,
  deviceVisiblePanel
}) => {
  let classNames = 'leftPanel';

  if (isDesktopLayout) {
    if (desktopVisiblePanel === 'both') {
      classNames = `col-md-3 ${classNames}`;
    } else {
      classNames = `noShow ${classNames}`;
    }
  } else {
    // eslint-disable-next-line no-lonely-if
    if (deviceVisiblePanel === 'left') {
      classNames = `col-sm-12 ${classNames}`;
    } else {
      classNames = `noShow ${classNames}`;
    }
  }

  return (
    <div className={classNames}>
      {isDesktopLayout || (!isDesktopLayout && deviceVisiblePanel === 'left')
        ? content
        : null}
    </div>
  );
};

LeftPanel.propTypes = {
  content: PropTypes.element,
  isDesktopLayout: PropTypes.bool.isRequired,
  desktopVisiblePanel: PropTypes.string.isRequired,
  deviceVisiblePanel: PropTypes.string.isRequired
};

export default LeftPanel;
