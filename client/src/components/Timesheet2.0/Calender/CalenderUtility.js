import { makeStyles } from "@material-ui/core";
export const modifiersStyles = {
    currentWeek: {
        color: "#FFFFFF",
        backgroundColor: "#008000"
    },
    disabled: {
        color: "#808080"
    }
};
export const styles = {
    caption: { color: "#008000", fontWeight: "bold" },
    head_cell: { color: "#008000" },
    day: {
        color: "#000000",
        border: "none",
        background: "none"
    }
};
export const useStyles = makeStyles(theme => ({
    root: {
        top: "20px",
        marginTop: "25px",
        width: "300px",
        height: "270px",
        zIndex: 3,
        position: "absolute",
        border: "2px solid #110f0f",
        borderRadius: "5px",
        padding: "5px",
        backgroundColor: "#FFFFFF"
    }
}));
