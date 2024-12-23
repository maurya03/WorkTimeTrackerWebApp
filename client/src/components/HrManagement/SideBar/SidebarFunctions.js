export const handleNavItemClick = async (
    activeLocation,
    setActiveLocation,
    location
) => {
    Object.keys(activeLocation).forEach(loc =>
        setActiveLocation(prev => {
            return { ...prev, [loc]: loc === location };
        })
    );
};
