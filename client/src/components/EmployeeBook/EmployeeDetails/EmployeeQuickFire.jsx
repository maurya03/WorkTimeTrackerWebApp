import React from "react";
import Stack from "@mui/material/Stack";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import EmployeeQuickFireFields from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeQuickFireFields.jsx";
import useMediaQuery from "@mui/material/useMediaQuery";

const EmployeeQuickFire = props => {
    const { employeeFieldData, isEdit, onFieldValueChange } = props;
    const isMobile = useMediaQuery("(max-width:767px)");

    return (
        <Stack
            width="100%"
            direction={isMobile ? "column" : "row"}
            mb="15px"
            sx={{ borderRadius: "10px" }}
        >
            <Box
                backgroundColor="#292e80"
                padding="10px 20px"
                color="#fff"
                borderRadius={isMobile ? "10px 10px 0px 0px" : "10px"}
                display="flex"
                alignItems="center"
                justifyContent="center"
                width={isMobile ? "100%" : "250px"}
                marginRight={isMobile ? "" : "20px"}
            >
                <Typography textAlign="center" variant="h4">
                    Quick Fire Question
                </Typography>
            </Box>
            <Stack
                justifyContent="space-evenly"
                backgroundColor="#efefef"
                borderRadius={isMobile ? "0px 0px 10px 10px" : "10px"}
                padding="10px 20px"
                width={isMobile ? "100%" : "calc(100% - 270px)"}
            >
                {employeeFieldData
                    ?.filter(record => record.isQuickFire === true)
                    .map(detail => {
                        return (
                            <EmployeeQuickFireFields
                                key={detail.id}
                                details={detail}
                                isEdit={isEdit}
                                onFieldchange={e => onFieldValueChange(e)}
                            />
                        );
                    })}
            </Stack>
        </Stack>
    );
};
export default EmployeeQuickFire;
