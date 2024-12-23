import React, { useState, useEffect, useRef } from "react";
import { ExpandMore } from "@material-ui/icons";
import cx from "classnames";
import ClientMenuList from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/ClientMenuList";
import CategoryMenuList from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/CategoryMenuList";
import css from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/Menu.css";
import menuFunctions from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/MenuFunctions.js";

const Menu = props => {
    const {
        clients,
        clientTeams,
        categories,
        activeClient,
        activeCategory,
        activeTeam,
        setActiveCategory,
        fetchTeamList,
        handleClientChange,
        handleCategoryChange,
        identifier,
        setIsButtonDisable
    } = props;
    const { onMenuExpand } = menuFunctions;
    const [showMenuList, setShowMenuList] = useState(false);
    const [activeMenu, setActiveMenu] = useState(null);
    const menuRef = useRef();
    const onMenuClick = e => {
        onMenuExpand(
            e,
            activeMenu,
            setActiveMenu,
            showMenuList,
            setShowMenuList
        );
    };

    useEffect(() => {
        const getDocumentClick = e => {
            if (menuRef.current && !menuRef.current.contains(e.target)) {
                setShowMenuList(false);
                setActiveMenu(null);
            }
        };

        document.addEventListener("mousedown", getDocumentClick);
        return () => {
            document.removeEventListener("mousedown", getDocumentClick);
        };
    }, [menuRef]);

    return (
        <section className={css.menuContainer} ref={menuRef}>
            {/* This is Menu title section starts*/}
            <section className={css.menuTitleContainer}>
                <div
                    className={cx(
                        css.menuTitle,
                        activeMenu === "clientMenu" && css.activeMenu
                    )}
                    id="clientMenu"
                >
                    <h5 className={css.heading}>Clients</h5>
                    <ExpandMore
                        className={css.menuExpandIcon}
                        onClick={e => onMenuClick(e)}
                    />
                </div>
                <div
                    className={cx(
                        css.menuTitle,
                        activeMenu === "technologyMenu" && css.activeMenu
                    )}
                    id="technologyMenu"
                >
                    <h5 className={css.heading}>Technologies</h5>
                    <ExpandMore
                        className={css.menuExpandIcon}
                        onClick={e => onMenuClick(e)}
                    />
                </div>
            </section>
            {/* This is Menu title section ends*/}

            {/* This is Menu list section */}
            <section
                className={cx(
                    css.menuListContainer,
                    showMenuList && css.menuListContainerVisible
                )}
            >
                <section
                    className={cx(
                        css.menuList,
                        activeMenu === "clientMenu" && css.menuListVisible
                    )}
                    data-id="clientMenu"
                >
                    <ClientMenuList
                        menuList={clients}
                        subMenuList={clientTeams}
                        fetchSubMenu={fetchTeamList}
                        activeClient={activeClient}
                        activeTeam={activeTeam}
                        handleMenuChange={handleClientChange}
                    />
                </section>
                <section
                    className={cx(
                        css.menuList,
                        activeMenu === "technologyMenu" && css.menuListVisible
                    )}
                    data-id="technologyMenu"
                >
                    <CategoryMenuList
                        menuList={categories}
                        activeCategory={activeCategory}
                        setActiveCategory={setActiveCategory}
                        handleMenuChange={handleCategoryChange}
                        identifier={identifier}
                        setIsButtonDisable={setIsButtonDisable}
                    />
                </section>
            </section>
            {/* This is Menu list section */}
        </section>
    );
};

export default Menu;
