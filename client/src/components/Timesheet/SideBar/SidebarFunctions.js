export const handleNavItemClick = async (
    activeLocation,
    setActiveLocation,
    location
) => {
    Object.keys(activeLocation).map(loc =>
        setActiveLocation(prev => {
            return { ...prev, [loc]: false };
        })
    );
    setActiveLocation(prev => {
        return { ...prev, [location]: true };
    });
};
