import React from "react";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

const ShareIdeaQuestionare = ({ details, onFieldchange }) => {
    return (
        <Box sx={{ marginBottom: 3 }}>
            <Typography
                id={details.id}
                variantMapping="p"
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
                <textarea
                    className="form-control"
                    rows={3}
                    id={details.id}
                    name={details.name}
                    value={details.answere}
                    onChange={e => onFieldchange(e)}
                />
            </Box>
        </Box>
    );
};

export default ShareIdeaQuestionare;
