import React, { useState } from "react";
import { Box, Typography, Stack, Grid, Button } from "@mui/material";
import ArrowForwardIosIcon from "@mui/icons-material/ArrowForwardIos";
import ArrowBackIosIcon from "@mui/icons-material/ArrowBackIos";
import { next, previous } from "rootpath/common/common";

const DrawerData = ({ data, setOpen }) => {
    const [record, setRecord] = useState(data?.model[0]);
    const [isArrowBackDisable, setIsArrowBackDisable] = useState(true);
    const [isArrowFrontDisable, setIsArrowFrontDisable] = useState(false);
    const [currentPage, setCurrentPage] = useState(1);
    const totalPages = data.model.length;
    return (
        <Box
            flexGrow={1}
            className="container"
            sx={{ minWidth: 800, maxHeight: 500 }}
        >
            <Box
                display="flex"
                p={1}
                m={1}
                borderRadius={1}
                flexDirection="row"
            >
                <Grid container spacing={1}>
                    <Grid xs={4}>
                        {isArrowBackDisable ? (
                            <ArrowBackIosIcon color="disabled" />
                        ) : (
                            <ArrowBackIosIcon
                                onClick={() =>
                                    setRecord(
                                        previous(
                                            data,
                                            record,
                                            setIsArrowBackDisable,
                                            setIsArrowFrontDisable,
                                            setCurrentPage
                                        )
                                    )
                                }
                            />
                        )}
                    </Grid>
                    <Grid xs={4}>
                        <Typography m="10px 0" textAlign="center" variant="h5">
                            {data.category}
                        </Typography>
                    </Grid>
                    <Grid xs={4} textAlign="end">
                        {isArrowFrontDisable ? (
                            <ArrowForwardIosIcon color="disabled" />
                        ) : (
                            <ArrowForwardIosIcon
                                onClick={() =>
                                    setRecord(
                                        next(
                                            data,
                                            record,
                                            setIsArrowBackDisable,
                                            setIsArrowFrontDisable,
                                            setCurrentPage
                                        )
                                    )
                                }
                            />
                        )}
                    </Grid>
                </Grid>
            </Box>
            <Box
                display="flex"
                justifyContent="center"
                alignItems="center"
                justify="center"
                p={1}
                m={1}
                fontWeight="fontWeightBold"
            >
                {record && record.fullName}
            </Box>
            <Box>
                <Stack spacing={1}>
                    {record &&
                        record.questionAnswer.length > 0 &&
                        record.questionAnswer.map(data => {
                            return (
                                <>
                                    <Box display="inline">
                                        <Typography
                                            level="h3"
                                            fontWeight="fontWeightBold"
                                            display="inline"
                                            m={1}
                                        >
                                            Question :
                                        </Typography>
                                        {data.question}
                                    </Box>
                                    <Box display="inline">
                                        <Typography
                                            level="h3"
                                            fontWeight="fontWeightBold"
                                            display="inline"
                                            m={1}
                                        >
                                            Answer :
                                        </Typography>
                                        {data.answer}
                                    </Box>
                                </>
                            );
                        })}
                </Stack>
            </Box>

            <Button
                variant="contained"
                size="medium"
                marginBottom="100px"
                sx={{ marginLeft: "650px" }}
                onClick={() => {
                    setOpen(false);
                }}
                style={{
                    position: "absolute",
                    bottom: "50px",
                    left: "unset",
                    right: "50px"
                }}
            >
                Back
            </Button>
            <Typography
                variant="h7"
                color="black"
                style={{
                    position: "absolute",
                    bottom: "150px",
                    left: "40px",
                    right: "0px",
                    top: "560px"
                }}
                size="medium"
                marginBottom="100px"
                sx={{ marginLeft: "350px" }}
            >
                {currentPage} of {totalPages}
            </Typography>
        </Box>
    );
};
export default DrawerData;
