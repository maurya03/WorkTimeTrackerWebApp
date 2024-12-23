import { getApi, postApi } from "../../baseApiService";
const baseURL = "api/v1";
export const PostClientScoreMappings = async scoreMappings => {
    const url = `${baseURL}/subCategoryMapping`;
    const response = await postApi(url, scoreMappings)
        .then(res => {
            window.alert("Data saved successfully!");
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const teamExpectedScoresListApi = async teamId => {
    const url = `${baseURL}/TeamSubCategoryMapping?teamId=${teamId}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data !== null) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const EmployeeScoresApi = async teamId => {
    const url = `${baseURL}/SkillsMatrixEmployeeScores?teamId=${teamId}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data !== null) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

const handleScoreSubmitData = (
    employee,
    subCategoryId,
    action,
    dataToSave,
    setDataToSave
) => {
    let findEmployee = dataToSave.findIndex(
        x =>
            x.bhavnaEmployeeId === employee.bhavnaEmployeeId &&
            x.subCategoryId === subCategoryId
    );
    if (findEmployee !== -1) {
        dataToSave[findEmployee].employeeScore =
            action === "increase"
                ? employee.employeeScore + 1
                : employee.employeeScore - 1;
    } else {
        dataToSave.push({
            bhavnaEmployeeId: employee.bhavnaEmployeeId,
            employeeScore:
                action === "increase"
                    ? employee.employeeScore + 1
                    : employee.employeeScore - 1,
            subCategoryId: subCategoryId,
            id: employee.mappingId
        });
    }
    setDataToSave(dataToSave);
};

export const handleEmployeeScoreChange = (
    columnName,
    subCategoryId,
    action,
    tableData,
    setTableData,
    dataToSave,
    setDataToSave,
    setIsButtonDisable
) => {
    const updatedData = tableData.map(item => {
        if (item.employeeList) {
            const updatedEmployeeList = item.employeeList.map(employee => {
                if (
                    employee.employeeName === columnName &&
                    employee.subCategoryId === subCategoryId
                ) {
                    if (action === "increase") {
                        if (employee.employeeScore !== 4) {
                            handleScoreSubmitData(
                                employee,
                                subCategoryId,
                                action,
                                dataToSave,
                                setDataToSave
                            );
                        }
                        return {
                            ...employee,
                            employeeScore:
                                employee.employeeScore == 4
                                    ? employee.employeeScore
                                    : employee.employeeScore + 1
                        };
                    } else if (action === "decrease") {
                        if (employee.employeeScore !== 0) {
                            handleScoreSubmitData(
                                employee,
                                subCategoryId,
                                action,
                                dataToSave,
                                setDataToSave
                            );
                        }
                        return {
                            ...employee,
                            employeeScore:
                                employee.employeeScore == 0
                                    ? employee.employeeScore
                                    : employee.employeeScore - 1
                        };
                    }
                }
                return employee;
            });

            return {
                ...item,
                employeeList: updatedEmployeeList
            };
        }
        return item;
    });
    setIsButtonDisable(false);
    setTableData(updatedData);
};

export const handleClientScoreChange = (
    newExpectedScoreRow,
    action,
    subCategoryMappings,
    setSubCategoryMappings,
    setIsButtonDisable
) => {
    const updatedData = subCategoryMappings.map(item => {
        if (item.id === newExpectedScoreRow.id) {
            if (
                action === "increase" &&
                newExpectedScoreRow.clientExpectedScore < 4
            ) {
                return {
                    ...item,
                    clientExpectedScore: item.clientExpectedScore + 1
                };
            } else if (
                action === "decrease" &&
                newExpectedScoreRow.clientExpectedScore > 0
            ) {
                return {
                    ...item,
                    clientExpectedScore: item.clientExpectedScore - 1
                };
            }
        }
        return item;
    });
    setSubCategoryMappings(updatedData);
    setIsButtonDisable(false);
};

export const clientTeamScoreMapping = (subcategories, teamExpectedScore) => {
    const newSubCategory = [];
    if (teamExpectedScore.length > 0) {
        subcategories.forEach(subcategory => {
            var matchingExpectedScore = teamExpectedScore.find(
                matchingcategory =>
                    matchingcategory.subCategoryId === subcategory.id
            );

            var clientExpectedScore = matchingExpectedScore
                ? matchingExpectedScore.expectedClientScore
                : 0;
            newSubCategory.push({ ...subcategory, clientExpectedScore }); // Add to the array
        });
    }
    return newSubCategory; // Return the array of mapped subcategories
};

export const getSkillMatrixTableData = async data => {
    const url = `${baseURL}/skillsMatrixTablesCheck`;
    const response = await postApi(url, data)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const PostEmployeeScoreMappings = async employeeScoringObject => {
    const url = `${baseURL}/SkillsMatrix`;
    const response = await postApi(url, employeeScoringObject)
        .then(res => {
            console.log("Data inserted successfully");
            alert("Data saved successfully!!!");
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
