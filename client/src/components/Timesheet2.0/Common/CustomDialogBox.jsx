import React from "react";
import DialogTitle from "@mui/material/DialogTitle";
import Dialog from "@mui/material/Dialog";
import Button from "@mui/material/Button";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import Box from "@mui/material/Box";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
const CustomDialogBox = ({ open, setOpen, title, content, onConfirm }) => {
    return (
        <Box margin="0" maxWidth="600px">
            <Dialog open={open} onClose={() => setOpen(false)}>
                <Box
                    display="flex"
                    alignItems="center"
                    justifyContent="space-between"
                    borderBottom="1px solid gray"
                    height="45px"
                    width="530px"
                >
                    <DialogTitle>{title}</DialogTitle>
                    <IconButton
                        aria-label="close"
                        onClick={() => setOpen(false)}
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

                <DialogContent>{content}</DialogContent>
                <DialogActions>
                    <Button
                        variant="contained"
                        color="secondary"
                        size="small"
                        onClick={() => setOpen(false)}
                    >
                        Cancel
                    </Button>
                    <Button
                        variant="contained"
                        color="primary"
                        size="small"
                        onClick={() => {
                            // setOpen(false);
                            onConfirm();
                        }}
                    >
                        Confirm
                    </Button>
                </DialogActions>
            </Dialog>
        </Box>
    );
};
export default CustomDialogBox;
