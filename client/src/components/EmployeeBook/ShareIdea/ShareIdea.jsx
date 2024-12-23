import React, { useEffect, useState } from "react";
import {
    Box,
    Typography,
    Button,
    Stack,
    Select,
    InputLabel,
    MenuItem,
    FormControl,
    Alert
} from "@mui/material";
import { HttpCodes } from "rootpath/services/EmployeeBook/employee/EmployeeDetail.js";
import {
    validateShareIdea,
    addOrReplaceQuestionAnswer
} from "rootpath/services/EmployeeBook/ShareIdeaService";
import ShareIdeaQuestionare from "rootpath/components/EmployeeBook/ShareIdea/ShareIdeaQuestionare";
import { useHistory } from "react-router-dom";
const ShareIdea = ({
    ideaCategory,
    fetchIdeaCategory,
    fetchIdeaQuestions,
    shareIdeaQuestions,
    saveIdea,
    userRole,
    history
}) => {
    const [questionAnswer, setQuestionAnswer] = useState([]);
    const [categoryId, setCategoryId] = useState();
    const [responseMessage, setResponseMessage] = useState("");
    const [showAlert, setShowAlert] = useState(false);
    const [severity, setSeverity] = useState("");

    const onHandleSaveChange = async () => {
        window.scrollTo({ top: 0, behavior: "smooth" });
        const validationResponse = validateShareIdea(
            categoryId,
            questionAnswer
        );
        if (!validationResponse.isValid) {
            setResponseMessage(validationResponse.errorMessage);
            setShowAlert(true);
            setSeverity("error");
        } else {
            const result = await saveIdea(categoryId, questionAnswer);
            if (result?.success?.status == HttpCodes.success) {
                setSeverity("success");
                setResponseMessage("Your idea saved successfully !!");
                setCategoryId();
                setQuestionAnswer([]);
                if (userRole?.roleName === "Admin") {
                    setTimeout(() => {
                        history.push("/employeebook/share-idea-details/");
                    }, 2000);
                } else {
                    setTimeout(() => {
                        history.push("/employeebook/");
                    }, 2000);
                }
            } else {
                setSeverity("error");
                setResponseMessage("Some error occured while saving idea !!");
            }
            setShowAlert(true);
        }
    };

    useEffect(() => {
        fetchIdeaCategory();
        fetchIdeaQuestions();
    }, [fetchIdeaCategory, fetchIdeaQuestions]);

    const onAnswerchange = e => {
        const addOrReplaceQA = addOrReplaceQuestionAnswer(questionAnswer, {
            questionId: e.target.id,
            answer: e.target.value
        });
        setQuestionAnswer(addOrReplaceQA);
    };

    return (
        <Box mt="40px" width="100%" className="container">
            {showAlert && (
                <Alert onClose={() => setShowAlert(false)} severity={severity}>
                    {responseMessage}
                </Alert>
            )}

            <Typography
                m="10px 0"
                textAlign="center"
                variant="h4"
                backgroundColor="#f3eeed"
                borderRadius="30px"
                marginBottom="20px"
            >
                Share Your Idea
            </Typography>

            <FormControl variant="filled" fullWidth sx={{ marginBottom: 1 }}>
                <Typography
                    variantMapping="p"
                    fontSize="18px"
                    color="#fff"
                    p="5px 20px"
                    sx={{
                        backgroundColor: "#159c49",
                        borderRadius: "8px 8px 0 0"
                    }}
                >
                    Category
                </Typography>
                {/* {!categoryId && (
                    <InputLabel sx={{ marginTop: "40px" }}>
                        Select Category
                    </InputLabel>
                )} */}
                <Select
                    m={1}
                    p={1}
                    id="category"
                    displayEmpty
                    inputProps={{ "aria-label": "Without label" }}
                    onChange={e => setCategoryId(e.target.value)}
                    sx={{
                        backgroundColor: "#FFFFFF",
                        borderRadius: "8px 8px 0 0",
                        marginBottom: "10px"
                    }}
                    value={categoryId}
                >
                    <MenuItem disabled>
                        <em>Select Category</em>
                    </MenuItem>
                    {ideaCategory &&
                        ideaCategory.length > 0 &&
                        ideaCategory.map(data => {
                            return (
                                <MenuItem id={data.id} value={data.id}>
                                    {data.category}
                                </MenuItem>
                            );
                        })}
                </Select>
            </FormControl>
            {shareIdeaQuestions &&
                shareIdeaQuestions.length > 0 &&
                shareIdeaQuestions.map(data => {
                    return (
                        <ShareIdeaQuestionare
                            details={data}
                            onFieldchange={onAnswerchange}
                        ></ShareIdeaQuestionare>
                    );
                })}
            <Box display="flex" justifyContent="center" alignItems="center">
                <Button
                    variant="contained"
                    size="large"
                    sx={{ margin: "50px", marginTop: "10px" }}
                    onClick={onHandleSaveChange}
                >
                    Save
                </Button>
            </Box>
        </Box>
    );
};
export default ShareIdea;
