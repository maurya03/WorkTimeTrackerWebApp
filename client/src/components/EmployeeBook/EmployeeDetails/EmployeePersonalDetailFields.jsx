import React from "react";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

const EmployeePersonalDetailFields = ({ details, isEdit, onFieldchange }) => {
    return (
        <Box
            border="1px solid #159c49"
            width="100%"
            borderRadius="10px"
            mb="15px"
        >
            <Typography
                // variant="p"
                fontSize="18px"
                color="#fff"
                p="5px 20px"
                sx={{
                    backgroundColor: "#159c49",
                    borderRadius: "8px 8px 0 0"
                }}
            >
                {details.question}
            </Typography>
            <Box>
                {isEdit ? (
                    <textarea
                        className="form-control"
                        rows={3}
                        id={details.id}
                        name={details.name}
                        value={details.answere}
                        onChange={e => onFieldchange(e)}
                    />
                ) : (
                    <Typography p="10px 20px" variant="body2">
                        {" "}
                        {details.answere}
                    </Typography>
                )}
            </Box>
        </Box>
    );
};

export default EmployeePersonalDetailFields;
