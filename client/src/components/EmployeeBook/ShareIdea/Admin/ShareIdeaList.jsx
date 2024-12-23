import React, { useEffect, useState } from "react";
import { Box, Typography, Drawer } from "@mui/material";
import MaterialTable from "@material-table/core";
import { shareIdeaCountsWithCategoryColumns } from "rootpath/services/EmployeeBook/ShareIdeaService";
import DrawerData from "rootpath/components/EmployeeBook/ShareIdea/Admin/DrawerData";

const ShareIdeaList = ({
    fetchShareIdeaCountsWithCategory,
    shareIdeaCountsWithCategory,
    userRole,
    fetchRole,
    fetchEmployeeShareIdea,
    employeeShareIdea
}) => {
    const [open, setOpen] = useState(false);
    const [drawerRecord, setDrawerRecord] = useState([]);

    useEffect(() => {
        fetchShareIdeaCountsWithCategory();
        fetchRole();
        fetchEmployeeShareIdea();
    }, [fetchShareIdeaCountsWithCategory, fetchRole, fetchEmployeeShareIdea]);

    const handleHomeClick = () => {
        history.push("/employeebook/");
    };

    const onRowClick = selectedRow => {
        const data = employeeShareIdea.find(
            x => x.categoryId == selectedRow.categoryId
        );
        data?.model?.forEach(function (row, index) {
            row.id = index;
        });
        setDrawerRecord(data);
        setOpen(true);
    };

    return userRole?.roleName === "Admin" ? (
        <Box flexGrow={1} className="container">
            <Drawer anchor="right" open={open} onClose={() => setOpen(false)}>
                <DrawerData data={drawerRecord} setOpen={setOpen} />
            </Drawer>
            <Box marginBottom="30px" width="90%">
                <Typography
                    variant="h4"
                    m="10px 0"
                    textAlign="center"
                    marginTop="20px"
                    marginBottom="20px"
                    backgroundColor="#f3eeed"
                    borderRadius="30px"
                >
                    Share Idea Counts With Category
                </Typography>

                <MaterialTable
                    onRowClick={(evt, selectedRow) => {
                        onRowClick(selectedRow);
                    }}
                    columns={shareIdeaCountsWithCategoryColumns}
                    data={shareIdeaCountsWithCategory}
                    options={{
                        search: true,
                        toolbar: false,
                        maxBodyHeight: "100%",
                        actionsColumnIndex: -1,
                        headerStyle: {
                            backgroundColor: "#17072b",
                            color: "#fff"
                        }
                    }}
                    style={{
                        height: "100%"
                    }}
                    localization={{
                        body: {
                            emptyDataSourceMessage:
                                "No share idea counts exist !!"
                        }
                    }}
                />
            </Box>
        </Box>
    ) : (
        <Box className="container">
            <Typography m="20px 0" textAlign="center" variant="h6">
                You do not have permission for this page.
            </Typography>
            <Typography
                m="20px 0"
                textAlign="center"
                variant="h6"
                backgroundColor="#fff"
                onClick={handleHomeClick}
                sx={{ cursor: "pointer", "&:hover": { color: "Blue" } }}
            >
                Go To Home Page
            </Typography>
        </Box>
    );
};
export default ShareIdeaList;
