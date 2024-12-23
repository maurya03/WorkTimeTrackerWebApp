import React from "react";
import Stack from "@mui/material/Stack";
import Typography from "@mui/material/Typography";
import useMediaQuery from "@mui/material/useMediaQuery";

const EmployeeQuickFireFields = ({ details, isEdit, onFieldchange }) => {
    const isMobile = useMediaQuery("(max-width: 767px)");

    return (
        <Stack
            direction={isMobile ? "column" : "row"}
            justifyContent="left"
            alignItems="left"
            sx={{ marginBottom: "10px" }}
        >
            <Stack
                direction="row"
                alignItems="left"
                justifyContent={isMobile ? "left" : "space-between"}
                width={isMobile ? "100%" : "30%"}
            >
                <Typography variant="h6" fontSize="15px" fontWeight="600">
                    {details.question}
                </Typography>
                {isMobile ? (
                    ""
                ) : (
                    <Typography
                        variant="h6"
                        fontSize="15px"
                        fontWeight="600"
                        textAlign="center"
                    >
                        :
                    </Typography>
                )}
            </Stack>
            <>
                {isEdit ? (
                    <textarea
                        className="form-control"
                        id={details.id}
                        name={details.name}
                        maxLength="2000"
                        rows="2"
                        value={details.answere}
                        placeholder="Maximum 2000 characters allowed"
                        onChange={e => onFieldchange(e)}
                    />
                ) : (
                    <Typography
                        fontSize="14px"
                        // variant="p"
                        width="70%"
                        marginLeft={isMobile ? "" : "10px"}
                    >
                        {details.answere}
                    </Typography>
                )}
            </>
        </Stack>
    );
};
export default EmployeeQuickFireFields;
