const onMenuExpand = (
    event,
    activeMenu,
    setActiveMenu,
    showMenuList,
    setShowMenuList
) => {
    const currentNode = event.target.nodeName;
    let currentMenu;
    if (currentNode === "svg") currentMenu = event.target.parentElement.id;
    if (currentNode === "path")
        currentMenu = event.target.parentElement.parentElement.id;
    if (activeMenu === currentMenu && showMenuList === true) {
        setShowMenuList(false);
        setActiveMenu(null);
    } else if (
        (activeMenu !== currentMenu && showMenuList === true) ||
        (activeMenu === currentMenu && showMenuList === false) ||
        (activeMenu !== currentMenu && showMenuList === false)
    ) {
        setShowMenuList(true);
        setActiveMenu(currentMenu);
    }
};

const menuFunctions = {
    onMenuExpand
};
export default menuFunctions;
