import React, { useState, useEffect } from "react";
import cx from "classnames";
import css from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/Menu.css";
import styles from "rootpath/styles/formStyles.css";

const ClientMenuList = props => {
    const [activeMenu, setActiveMenu] = useState(null);
    const [activeSubMenu, setActiveSubMenu] = useState(null);
    const {
        menuList,
        subMenuList,
        fetchSubMenu,
        activeClient,
        activeTeam,
        handleMenuChange
    } = props;
    useEffect(() => {
        menuList && menuList.length > 0 && setActiveMenu(activeClient);
        subMenuList &&
            subMenuList.length > 0 &&
            setActiveSubMenu(activeTeam || subMenuList[0].id);
    }, [menuList, activeClient, subMenuList]);

    const getSubMenu = async item => {
        await fetchSubMenu(item.id);
        setActiveMenu(item);
    };

    const handleTeamChange = item => {
        handleMenuChange(activeMenu, item);
    };
    return (
        <section className={css.menuItemsContainer}>
            <div className={cx(css.menuListItems, styles.scrollbar)}>
                {menuList.length > 0 &&
                    menuList.map((menuItem, index) => {
                        return (
                            <span
                                key={index}
                                className={cx(
                                    css.menuItem,
                                    activeMenu &&
                                        activeMenu.clientName ===
                                            menuItem.clientName &&
                                        css.activeMenuItem
                                )}
                                onClick={() => getSubMenu(menuItem)}
                            >
                                {menuItem.clientName}
                            </span>
                        );
                    })}
            </div>
            {subMenuList?.length > 0 && (
                <div className={cx(css.subMenuListItems, styles.scrollbar)}>
                    {subMenuList.map((subMenuItem, index) => {
                        return (
                            <span
                                key={index}
                                className={cx(
                                    css.subMenuItem,
                                    activeSubMenu &&
                                        activeTeam.id === subMenuItem.id &&
                                        css.activeSubMenu
                                )}
                                onClick={() => handleTeamChange(subMenuItem)}
                            >
                                {subMenuItem.teamName}
                            </span>
                        );
                    })}
                </div>
            )}
        </section>
    );
};

export default ClientMenuList;
