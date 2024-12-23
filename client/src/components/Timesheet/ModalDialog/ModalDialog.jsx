import React from "react";
import { styled } from "@mui/material/styles";
import Dialog from "@mui/material/Dialog";
import DialogTitle from "@mui/material/DialogTitle";
import DialogContent from "@mui/material/DialogContent";
import DialogActions from "@mui/material/DialogActions";
import { IconButton } from "@mui/material";
import CloseIcon from "@mui/icons-material/Close";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import styles from "rootpath/components/Timesheet/ModalDialog/ModalDialog.css";
import { rejected } from "rootpath/components/Timesheet/Constants";
import { Alert } from "@mui/material";
import Box from "@mui/material/Box";
const BootstrapDialog = styled(Dialog)(({ theme }) => ({
    "& .MuiDialogContent-root": {
        padding: theme.spacing(2)
    },
    "& .MuiDialogActions-root": {
        padding: theme.spacing(1)
    }
}));
const ModalDialog = ({
    handleClose,
    handleRejectConfirm,
    isRemarksModalOpen,
    errorMessage,
    debouncedSetRemarks
}) => {
    return (
        <BootstrapDialog
            onClose={handleClose}
            aria-labelledby="customized-dialog-title"
            open={isRemarksModalOpen}
        >
            <Box
                display="flex"
                alignItems="center"
                justifyContent="space-between"
            >
                <DialogTitle sx={{ m: 0, p: 2 }} id="customized-dialog-title">
                    Reject Timesheet Remarks
                </DialogTitle>
                <IconButton
                    aria-label="close"
                    onClick={handleClose}
                    sx={{
                        position: "absolute",
                        right: 8,
                        top: 8,
                        color: theme => theme.palette.grey[500]
                    }}
                >
                    <CloseIcon />
                </IconButton>
            </Box>

            <DialogContent dividers>
                {errorMessage.length > 0 && (
                    <Alert
                        variant="filled"
                        severity={"warning"}
                        style={{ position: "relative" }}
                    >
                        {errorMessage[0].error}
                    </Alert>
                )}
                <Typography gutterBottom>
                    <textarea
                        className={styles.textarea}
                        rows={4}
                        onChange={e => debouncedSetRemarks(e.target.value)}
                    />
                </Typography>
            </DialogContent>
            <DialogActions>
                <Button
                    variant="contained"
                    color="secondary"
                    size="small"
                    onClick={handleClose}
                    autoFocus
                >
                    Cancel
                </Button>
                <Button
                    variant="contained"
                    color="primary"
                    size="small"
                    autoFocus
                    onClick={() => handleRejectConfirm(rejected)}
                >
                    Confirm
                </Button>
            </DialogActions>
        </BootstrapDialog>
    );
};
export default ModalDialog;
