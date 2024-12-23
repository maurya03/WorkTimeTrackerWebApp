import React, { useState, useRef, useEffect } from "react";
import TextareaAutosize from "@material-ui/core/TextareaAutosize";
import TableCell from "@material-ui/core/TableCell";
import FormHelperText from "@material-ui/core/FormHelperText";
import css from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2.css";

const CustomTextArea = ({
    row,
    index,
    errors,
    duplicateErrors,
    debouncedTaskDescriptionChange
}) => {
    const [taskDescription, setTaskDescription] = useState(row.taskDescription);
    const inputRef = useRef(null);
    useEffect(() => {
        setTaskDescription(row.taskDescription);
    }, [row.taskDescription]);

    useEffect(() => {
        if (inputRef.current) {
            const inputElement = inputRef.current;
            const { selectionStart, selectionEnd } = inputElement;
            inputElement.setSelectionRange(selectionStart, selectionEnd);
        }
    }, [taskDescription]);

    return (
        <TableCell style={{ width: "20%", padding: "6px" }}>
            <TextareaAutosize
                ref={inputRef}
                value={taskDescription}
                style={{
                    width: "100%",
                    minHeight: 45,
                    marginTop: 6,
                    borderColor:
                        (errors[index] && !taskDescription.trim()) ||
                        duplicateErrors[index]
                            ? "#FF0000"
                            : ""
                }}
                error={errors[index] && !taskDescription.trim()}
                onChange={e => {
                    setTaskDescription(e.target.value);
                    debouncedTaskDescriptionChange(
                        e.target.value,
                        row.id,
                        index
                    );
                }}
                maxRows={10}
                className={css.taskField}
            />
            {errors[index] && !row.taskDescription.trim() && (
                <FormHelperText
                    style={{
                        color: "#FF0000"
                    }}
                >
                    Invalid Description
                </FormHelperText>
            )}
            {duplicateErrors[index] && (
                <FormHelperText
                    style={{
                        color: "#FF0000"
                    }}
                >
                    Duplicate task
                </FormHelperText>
            )}
        </TableCell>
    );
};
export default CustomTextArea;
