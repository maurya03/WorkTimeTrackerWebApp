import React, { useEffect, useState } from "react";
import moment from "moment";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import { read, utils } from "xlsx";
import { uploadEmployeeExcelData } from "rootpath/services/EmployeeBook/employee/EmployeeService";
import { withRouter } from "react-router-dom";
// import { useHistory } from "react-router-dom";

const ImportEmployees = ({ userRole, fetchRole, history }) => {
    const [file, setFile] = useState(null);
    const [errorMessage, setErrorMessage] = useState(null);
    const [employeesExcelData, setEmployeesExcelData] = useState([]);

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    useEffect(() => {
        window.scrollTo(0, 0);
        uploadEmployeeExcelData(employeesExcelData);
    }, [employeesExcelData]);

    const onInputFileChange = async event => {
        const file = event.target.files[0];
        if (file) {
            const isValidFormat = validateFileFormat(file);
            if (isValidFormat) {
                setFile(file);
                setErrorMessage(null);
            } else {
                setFile(null);
                setErrorMessage("Please select an Excel file (.xlsx format).");
            }
        } else {
            setFile(null);
            setErrorMessage(null);
        }
    };

    const validateFileFormat = file => {
        const extension = file.name.split(".").pop().toLowerCase();
        return extension === "xlsx";
    };

    const handleUploadFile = async () => {
        if (file) {
            const reader = new FileReader();
            reader.onload = e => {
                const data = e.target.result;
                const workbook = read(data, { type: "binary" });
                const sheetName = workbook.SheetNames[0];
                const worksheet = workbook.Sheets[sheetName];
                const json = utils.sheet_to_json(worksheet);
                const recordsToSave = json.map(record => {
                    const data = {
                        ...record,
                        EmployeeId: record.EmployeeId.toString(),
                        DateJoining: moment(
                            new Date(
                                Math.round((record.DateJoining - 25569) * 864e5)
                            )
                        ).format("DD/MM/YYYY")
                    };
                    return data;
                });
                var JsonString = JSON.stringify(recordsToSave, null, 2);

                setEmployeesExcelData(JsonString);
            };
            reader.readAsBinaryString(file);
        }
    };
    const handleHomeClick = () => {
        history.push("/employeebook/");
    };

    return userRole?.roleName === "Admin" ? (
        <Box className="container">
            <Typography
                m="10px 0"
                textAlign="center"
                variant="h4"
                backgroundColor="#f3eeed"
                borderRadius="30px"
                margin="20px"
            >
                Import Employees
            </Typography>
            <Box mt="10px">
                <Typography
                    variant="h5"
                    sx={{ fontWeight: "bold", m: 1, marginLeft: "60px" }}
                >
                    Steps to import employees
                </Typography>
                <Typography marginLeft="60px">
                    <ol>
                        <li>
                            Data can only be imported from the Excel (.xls or
                            .xlsx) file with the sheet name as 'Sheet1'.
                        </li>
                        <li>Click on &lt;Choose File&gt; button below. </li>
                        <li>Select the file and click &lt;Open&gt; button.</li>
                        <li>Click on &lt;Upload Now&gt; button.</li>
                    </ol>
                </Typography>
            </Box>
            <Stack direction="row" marginLeft="100px" marginTop="30px">
                <TextField
                    type="file"
                    id="excelFileInput"
                    name="excelFileInput"
                    size="medium"
                    textAlign="center"
                    sx={{ width: "250px" }}
                    onChange={onInputFileChange}
                    error={!!errorMessage}
                    helperText={errorMessage}
                    accept=".xlsx"
                />

                <Button
                    variant="contained"
                    size="mediumm"
                    sx={{
                        marginLeft: "20px",
                        marginTop: "10px",
                        height: "40px"
                    }}
                    disabled={errorMessage !== null ? true : false}
                    onClick={handleUploadFile}
                >
                    Upload Now
                </Button>
            </Stack>
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
export default withRouter(ImportEmployees);
