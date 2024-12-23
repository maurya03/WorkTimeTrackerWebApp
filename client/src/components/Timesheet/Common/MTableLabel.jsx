import React from "react";
const MTableLabel = ({ rowData, bindingList, keyName, value }) => {
    return (
        rowData[keyName] && (
            <label>
                {bindingList.length > 0 &&
                    bindingList.filter(x => x[keyName] === rowData[keyName])
                        .length > 0 &&
                    bindingList.filter(x => x[keyName] === rowData[keyName])[0][
                        value
                    ]}
            </label>
        )
    );
};
export default MTableLabel;
