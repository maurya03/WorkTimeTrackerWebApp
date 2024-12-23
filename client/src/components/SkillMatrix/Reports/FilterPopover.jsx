import React, { Fragment } from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import Checkbox from "@mui/material/Checkbox";
import Popover from "@mui/material/Popover";
import Stack from "@mui/material/Stack";
import Typography from "@mui/material/Typography";

const FilterPopover = ({
    activePopover,
    handleFilterReset,
    categories,
    clients,
    teams,
    empTypeList,
    activeCategoryFunction,
    activeClient,
    activeTeam,
    activeType,
    isCategoryWiseChecked,
    setIsCategoryWiseChecked,
    setIsFilterDisable,
    setActivePopover,
    setActiveCategoryFunction,
    setActiveClient,
    setActiveTeam,
    setActiveType,
    activeReport,
    isFilterDisable,
    setIsFilterApplied,
    fetchDataByActiveReportType,
    selectedYearAndMonth
}) => {
    const open = Boolean(activePopover);
    const popoverId = open ? "filter-popover" : undefined;
    return (
        <Popover
            id={popoverId}
            open={open}
            anchorEl={activePopover}
            onClose={() => {
                setActivePopover(null);
            }}
            anchorOrigin={{
                vertical: "center",
                horizontal: "right"
            }}
            transformOrigin={{
                vertical: "bottom",
                horizontal: "right"
            }}
        >
            <Box p={2}>
                <Stack direction="column">
                    <Typography
                        style={{
                            color: "#808080",
                            marginLeft: "5px",
                            marginTop: "15px",
                            marginBottom: "-3px",
                            fontSize: "12px"
                        }}
                        shrink={true}
                    >
                        Category Function
                    </Typography>
                    <Select
                        size="small"
                        style={{ minWidth: 300 }}
                        value={activeCategoryFunction}
                        onChange={event => {
                            setActiveCategoryFunction(event.target.value);
                            setIsFilterDisable(false);
                        }}
                    >
                        <MenuItem value={0}>All</MenuItem>
                        {categories &&
                            categories.map(item => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.categoryFunction}
                                </MenuItem>
                            ))}
                    </Select>
                    <Typography
                        style={{
                            color: "#808080",
                            marginLeft: "5px",
                            marginTop: "15px",
                            marginBottom: "-3px",
                            fontSize: "12px"
                        }}
                        shrink={true}
                    >
                        Client
                    </Typography>
                    <Select
                        size="small"
                        style={{ minWidth: 300 }}
                        value={activeClient}
                        onChange={event => {
                            setActiveTeam(0);
                            setActiveClient(event.target.value);
                            setIsFilterDisable(false);
                        }}
                    >
                        <MenuItem value={0}>All</MenuItem>
                        {clients &&
                            clients.map(item => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.clientName}
                                </MenuItem>
                            ))}
                    </Select>
                    {activeReport === "Report By Employee Score" && (
                        <Fragment>
                            <Typography
                                style={{
                                    color: "#808080",
                                    marginLeft: "5px",
                                    marginTop: "15px",
                                    marginBottom: "-3px",
                                    fontSize: "12px"
                                }}
                                shrink={true}
                            >
                                Team
                            </Typography>
                            <Select
                                size="small"
                                style={{ minWidth: 300 }}
                                value={activeTeam}
                                onChange={event => {
                                    setActiveTeam(event.target.value);
                                    setIsFilterDisable(false);
                                }}
                            >
                                <MenuItem value={0}>All</MenuItem>
                                {teams &&
                                    teams.length &&
                                    teams.map(item => (
                                        <MenuItem key={item.id} value={item.id}>
                                            {item.teamName}
                                        </MenuItem>
                                    ))}
                            </Select>
                            {isCategoryWiseChecked && (
                                <Stack>
                                    <Typography
                                        style={{
                                            color: "#808080",
                                            marginLeft: "5px",
                                            marginTop: "15px",
                                            marginBottom: "-3px",
                                            fontSize: "12px"
                                        }}
                                        shrink={true}
                                    >
                                        Type
                                    </Typography>
                                    <Select
                                        size="small"
                                        style={{ minWidth: 300 }}
                                        value={activeType}
                                        onChange={event => {
                                            setActiveType(event.target.value);
                                            setIsFilterDisable(false);
                                        }}
                                    >
                                        <MenuItem value={0}>All</MenuItem>
                                        {teams &&
                                            empTypeList.map(item => (
                                                <MenuItem
                                                    key={item.id}
                                                    value={item.id}
                                                >
                                                    {item.function_Type}
                                                </MenuItem>
                                            ))}
                                    </Select>
                                </Stack>
                            )}
                            <Stack
                                direction="row"
                                alignItems="center"
                                style={{ flex: 1 }}
                            >
                                <Checkbox
                                    checked={isCategoryWiseChecked}
                                    style={{
                                        color: "rgba(23, 7, 43)"
                                    }}
                                    onChange={() => {
                                        setIsCategoryWiseChecked(
                                            !isCategoryWiseChecked
                                        );
                                        setIsFilterDisable(false);
                                    }}
                                />

                                <Typography>Show Categorywise</Typography>
                            </Stack>
                        </Fragment>
                    )}
                    <Stack
                        direction="row"
                        justifyContent="flex-end"
                        alignItems="center"
                    >
                        <Button
                            variant="contained"
                            sx={{
                                alignSelf: "flex-end",
                                mt: "15px"
                            }}
                            disabled={isFilterDisable}
                            onClick={() => {
                                setActivePopover(null);
                                setIsFilterApplied(true);
                                fetchDataByActiveReportType(
                                    activeReport,
                                    activeCategoryFunction,
                                    activeClient,
                                    activeTeam,
                                    isCategoryWiseChecked,
                                    activeType,
                                    selectedYearAndMonth.year,
                                    selectedYearAndMonth.month
                                );
                            }}
                        >
                            Filter
                        </Button>
                        <Button
                            variant="light"
                            sx={{
                                alignSelf: "flex-end",
                                mt: "15px"
                            }}
                            disabled={isFilterDisable}
                            onClick={() => {
                                handleFilterReset();
                                fetchDataByActiveReportType(
                                    activeReport,
                                    0,
                                    0,
                                    0,
                                    true,
                                    0,
                                    selectedYearAndMonth.year,
                                    selectedYearAndMonth.month
                                );
                            }}
                        >
                            Reset
                        </Button>
                    </Stack>
                </Stack>
            </Box>
        </Popover>
    );
};

export default FilterPopover;
