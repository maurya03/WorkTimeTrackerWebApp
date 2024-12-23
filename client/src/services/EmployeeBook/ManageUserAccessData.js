export const updateSelectedRole = (roles, selectedValue) => {
    if (roles && roles.length > 0) {
        return roles.map(obj => {
            if (obj.roleId === selectedValue?.roleId) {
                return { ...obj, isChecked: true };
            } else {
                return obj;
            }
        });
    }
};

export const onOptionSelected = (roles, event) => {
    if (event && roles && roles.length > 0) {
        const { target } = event;
        return roles.map(obj => {
            if (obj.roleId === parseInt(target.value)) {
                return { ...obj, isChecked: true };
            } else {
                return { ...obj, isChecked: false };
            }
        });
    }
};
