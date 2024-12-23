import PropTypes from 'prop-types';
import React from 'react';
// eslint-disable-next-line
import LogoutButton from '../../login/containers/LogoutButton';
import classes from '../css/headerAlt.css';
import format from 'date-fns/format';
import Link from 'react-router/lib/Link';
import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import AlertButton from '../../alerts/containers/AlertButton';
import TaskEditingButton from '../../taskEditor/containers/TaskEditingButton';
import PatientPicture from 'srs/common/containers/PatientPicture';

const Header = ({
  isDesktopLayout,
  isTaskingEnabled,
  desktopVisiblePanel,
  deviceVisiblePanel,
  onDesktopToggleFullscreen,
  onSmallTogglePanels,
  selectedName,
  encounterTime,
  personId,
  prevPathname,
  prevSearch,
}) => {
  let iconName = null;
  if (isDesktopLayout) {
    iconName = desktopVisiblePanel === 'both' ?
      'cust-fa-column' : 'fa fa-columns';
  } else {
    iconName = (deviceVisiblePanel === 'left') ?
      'fa fa-angle-double-left' : 'fa fa-angle-double-right';
  }

  return (
    <header className="srs-header-primary">
      <div className={classes.container} >
        <div style={{ textAlign: 'left' }} >
          <ReactCSSTransitionGroup
            transitionEnterTimeout={325}
            transitionLeaveTimeout={325}
            transitionName={{
              enter: classes.enter,
              enterActive: classes.enterActive,
              leave: classes.leave,
              leaveActive: classes.leaveActive,
            }}
          >
            {
              personId ?
                <div className="btn-group">
                  <Link
                    disabled={!personId}
                    data-auto="LinkButton_HeaderBar"
                    className={`${classes.userButton} ${classes.headerButton} btn btn-primary`}
                    to={`${prevPathname}${prevSearch}`}
                  >
                    <i
                      className={`${classes.goBackButton} fa fa-level-up`}
                      aria-hidden="true"
                    />
                    <PatientPicture personId={personId} className={classes.userButtonImage} cacheId="head1" />
                    <span className="hidden-xs">{selectedName === '' ? <i>No Name</i> : selectedName}</span>
                  </Link>
                  <Link
                    type="button"
                    id="btnEncounters"
                    title="Patient Encounters"
                    to={`/patientEncounter?personId=${personId}`}
                    className={`${classes.encounterButton} ${classes.headerButton} btn btn-primary`}
                  >
                    <div>
                      <span className="hidden-xs" title="Doctor Name" />
                      {encounterTime ? (format(encounterTime, 'hh:mm A')) : 'No encounter' }
                    </div>
                    {encounterTime ? (format(encounterTime, 'MM/DD/YYYY')) : null }
                  </Link>
                  <AlertButton />
                  {isTaskingEnabled && encounterTime ? <TaskEditingButton /> : null }
                </div>
                : null
            }
          </ReactCSSTransitionGroup>
        </div>
        <div>
          <LogoutButton
            style={{ marginRight: '5px' }}
            className={`${classes.headerButton} btn btn-primary`}
            hideLogoutWhenSmall
          />
          <button
            type="button"
            className={`${classes.headerButton} btn btn-primary`}
            onClick={isDesktopLayout ? onDesktopToggleFullscreen : onSmallTogglePanels}
          >
            <i className={iconName} aria-hidden="true" />
          </button>
        </div>
      </div>
    </header>
  );
};

Header.propTypes = {
  isDesktopLayout: PropTypes.bool.isRequired,
  isTaskingEnabled: PropTypes.bool.isRequired,
  deviceVisiblePanel: PropTypes.string.isRequired,
  desktopVisiblePanel: PropTypes.string.isRequired,
  onDesktopToggleFullscreen: PropTypes.func.isRequired,
  onSmallTogglePanels: PropTypes.func.isRequired,
  selectedName: PropTypes.string,
  encounterTime: PropTypes.string,
  prevPathname: PropTypes.string,
  prevSearch: PropTypes.string,
  personId: PropTypes.number,
};

export default Header;
