import React, { useState, useEffect, useMemo } from "react";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import TextField from "@mui/material/TextField";
import Box from "@mui/material/Box";
import { InterestList, SortByList } from "rootpath/common/common";
import Button from "@mui/material/Button";
import useMediaQuery from "@mui/material/useMediaQuery";
import debouce from "lodash.debounce";

const EmployeeSearchAndFilter = props => {
    const {
        projectList,
        searchParam,
        onSearchParamChange,
        onHandleSearch,
        clearEmployeeSearchParam,
        setSearchParam,
        employeeList
    } = props;
    const [interest, setInterest] = useState("");
    const [project, setProject] = useState("");
    const [sortBy, setSortBy] = useState("NameAsc");
    const [allProjects, setAllProjects] = useState([]);
    const [searchText, setSearchText] = useState("");
    const [flexItemWidth, setFlexItemWidth] = useState("");
    const isMobile = useMediaQuery("(max-width: 767px)");
    const isIPad = useMediaQuery("(min-width: 768px) and (max-width:1024px)");

    useEffect(() => {
        isMobile && setFlexItemWidth("60%");
        isIPad && setFlexItemWidth("40%");
    }, [isMobile, isIPad]);

    useEffect(() => {
        setInterest(searchParam?.interests);
        setProject(searchParam?.projectId);
        setSortBy(searchParam?.sortBy);
        setSearchText(searchParam?.searchText);
    }, []);

    useEffect(() => {
        setAllProjects(projectList);
    }, [projectList]);

    const onSelectOptionChange = (e, type) => {
        type === "interest" && setInterest(e.target.value);
        type === "project" && setProject(e.target.value);
        type === "sortBy" && setSortBy(e.target.value);
        onSearchParamChange(e);
    };

    const clearFilter = async () => {
        setSearchParam({
            page: 1,
            pageSize: 6,
            projectId: 0,
            interests: "All",
            searchText: "",
            sortBy: "NameAsc"
        });
        await clearEmployeeSearchParam(employeeList);
        setProject(0);
        setInterest("All");
        setSortBy("NameAsc");
        setSearchText("");
    };

    const handleChange = e => {
        setSearchText(e.target.value);
        onSearchParamChange(e);
    };

    const debouncedResults = debouce(handleChange, 300);

    useEffect(() => {
        //This useEffect is require for debounced result cleanup
        return () => {
            debouncedResults.cancel();
        };
    });

    return (
        <Box
            display="flex"
            alignItems="center"
            justifyContent="space-between"
            sx={{ flexWrap: "wrap" }}
        >
            <TextField
                id="searchText"
                label="Search Employee"
                name="searchText"
                type="search"
                size="small"
                value={searchText}
                onChange={handleChange}
                style={{
                    marginRight: isMobile ? "0" : "10px",
                    marginBottom: "10px",
                    flex: flexItemWidth
                }}
            />
            <FormControl
                sx={{
                    width: 200,
                    marginRight: isMobile ? "0" : "10px",
                    marginBottom: "10px",
                    flex: flexItemWidth
                }}
                size="small"
            >
                <InputLabel id="select-interest-label">Interests</InputLabel>
                <Select
                    labelId="select-interest-label"
                    id="select-interest"
                    name="interests"
                    value={interest}
                    label="Interests"
                    onChange={e => onSelectOptionChange(e, "interest")}
                >
                    {InterestList &&
                        InterestList.length > 0 &&
                        InterestList.map(interest => (
                            <MenuItem
                                key={interest.value}
                                value={interest.value}
                            >
                                {interest.text}
                            </MenuItem>
                        ))}
                </Select>
            </FormControl>
            <FormControl
                sx={{
                    width: 200,
                    marginRight: isMobile ? "0" : "10px",
                    marginBottom: "10px",
                    flex: flexItemWidth
                }}
                size="small"
            >
                <InputLabel id="select-project-label">Projects</InputLabel>
                <Select
                    labelId="select-project-label"
                    id="select-project"
                    value={project}
                    name="projectId"
                    label="Projects"
                    onChange={e => onSelectOptionChange(e, "project")}
                >
                    <MenuItem key={0} value={0}>
                        All
                    </MenuItem>
                    {allProjects?.length > 0 &&
                        allProjects?.map(project => (
                            <MenuItem key={project.id} value={project.id}>
                                {project.projectName}
                            </MenuItem>
                        ))}
                </Select>
            </FormControl>
            <FormControl
                sx={{
                    width: 200,
                    marginRight: isMobile ? "0" : "10px",
                    marginBottom: "10px",
                    flex: flexItemWidth
                }}
                size="small"
            >
                <InputLabel id="select-sortby-label">Sort By:</InputLabel>
                <Select
                    labelId="select-sortby-label"
                    name="sortBy"
                    id="sortBy"
                    value={sortBy}
                    label="Sort By:"
                    onChange={e => onSelectOptionChange(e, "sortBy")}
                >
                    {SortByList &&
                        SortByList.length > 0 &&
                        SortByList.map(sortBy => (
                            <MenuItem key={sortBy.value} value={sortBy.value}>
                                {sortBy.text}
                            </MenuItem>
                        ))}
                </Select>
            </FormControl>
            <FormControl
                sx={{
                    width: 200,
                    marginRight: "10px",
                    marginBottom: "10px",
                    flex: flexItemWidth
                }}
                size="small"
            >
                <Button
                    variant="contained"
                    size="large"
                    sx={{
                        width: "200px",
                        borderRadius: "10px"
                    }}
                    onClick={clearFilter}
                >
                    Clear Filter
                </Button>
            </FormControl>
        </Box>
    );
};

export default EmployeeSearchAndFilter;
