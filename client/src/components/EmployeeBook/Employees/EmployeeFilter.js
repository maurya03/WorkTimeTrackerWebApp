export const filterEmployees = (employeeList, filters) => {
    if (employeeList && employeeList.length > 0) {
        let filteredEmployees = employeeList.filter(employee => {
            return (
                (filters.projectId === 0 ||
                    employee.projectId === filters.projectId) &&
                (filters.interests === "All" ||
                    employee.hobbiesAndInterests
                        ?.toLowerCase()
                        .includes(filters.interests.toLowerCase())) &&
                (!filters.searchText ||
                    employee.employeeName
                        .toLowerCase()
                        .includes(filters.searchText.toLowerCase()))
            );
        });

        // Sorting logic
        if (filters.sortBy === "NameAsc") {
            filteredEmployees.sort((a, b) =>
                a.employeeName.localeCompare(b.employeeName)
            );
        } else if (filters.sortBy === "NameDesc") {
            filteredEmployees.sort((a, b) =>
                b.employeeName.localeCompare(a.employeeName)
            );
        }

        filteredEmployees.forEach((employee, index) => {
            employee.rowId = index + 1;
        });

        const totalpage = {
            totalRecords: filteredEmployees.length,
            totalPages: Math.ceil(filteredEmployees.length / filters.pageSize)
        };

        const startIndex = (filters.page - 1) * filters.pageSize + 1;
        const endIndex = startIndex + filters.pageSize - 1;

        filteredEmployees = filteredEmployees.filter(
            employee =>
                employee.rowId >= startIndex && employee.rowId <= endIndex
        );

        return { employees: filteredEmployees, totalpage: totalpage };
    }
};
