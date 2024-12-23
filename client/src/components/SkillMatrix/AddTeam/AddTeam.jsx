import React, { useEffect, useState } from "react";
import css from "rootpath/styles/formStyles.css";
import { validationInput } from "rootpath/components/SkillMatrix/commonValidationFunction";
import { getClientsTeamsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import CustomAlert from "rootpath/components/CustomAlert";
import { faL } from "@fortawesome/free-solid-svg-icons";

const AddTeam = ({
    selectedClient,
    showDrawer,
    setShowDrawer,
    client,
    addTeamFormVisible,
    setaddTeamFormVisible,
    postTeam,
    setTeams,
    selectedTeam,
    updateTeam,
    setIsEdit,
    showErrorMessage,
    showAlert,
    setShowAlert
}) => {
    const [team, setTeam] = useState({
        clientId: selectedClient?.id || client.id,
        teamName: selectedTeam?.teamName || "",
        teamDescription: selectedTeam?.teamDescription || "",
        createdOn: new Date().toJSON(),
        modifiedOn: new Date().toJSON()
    });
    const [errorMessage, setErrorMessage] = useState([]);
    const handlechange = e => {
        setTeam(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
    };
    useEffect(async () => {
        if (selectedTeam) {
            let team = {};
            team.teamName = selectedTeam.teamName;
            team.teamDescription = selectedTeam.teamDescription;
            team.id = selectedTeam.id;
        }
        setTeam(team);
    }, [selectedTeam]);
    const addTeamRecord = async state => {
        const result = await postTeam(state);
        const teams = await getClientsTeamsList(team.clientId);
        setTeams(teams);
        if (result?.success) {
            closeDrawer();
            setShowAlert(true, "success", "Team added successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const updateTeamRecord = async state => {
        const result = await updateTeam(state);
        const teams = await getClientsTeamsList(team.clientId);
        setTeams(teams);
        if (result?.success) {
            closeDrawer();
            setShowAlert(true, "success", "Team updated successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const closeDrawer = () => {
        setShowAlert(false);
        setaddTeamFormVisible(!addTeamFormVisible);
        setShowDrawer(!showDrawer);
        setIsEdit(false);
    };
    const onSubmitClick = () => {
        var validate = validationInput(team, "team");
        setErrorMessage(validate);
        if (validate.length === 0) {
            if (Object.keys(selectedTeam).length > 0) {
                team.id = selectedTeam.id;
                team.modifiedOn = new Date().toJSON();
                updateTeamRecord(team);
            } else {
                addTeamRecord(team);
            }
        }
    };

    return (
        <div className={css.formDrawer}>
            <div className={css.formContainer}>
                {showAlert.severity === "error" &&
                    Object.keys(showAlert).length > 0 && (
                        <CustomAlert
                            open={showAlert.setAlert}
                            severity={showAlert.severity}
                            message={showAlert.message}
                            onClose={() =>
                                setShowAlert(
                                    false,
                                    showAlert.severity,
                                    showAlert.message
                                )
                            }
                        ></CustomAlert>
                    )}
                <label className={css.label}>Team Name</label>
                <input
                    className={css.formInput}
                    defaultValue={selectedTeam.teamName}
                    id="teamName"
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Enter team name"
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Name" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Team Description</label>
                <textarea
                    rows={7}
                    className={css.description}
                    defaultValue={selectedTeam.teamDescription}
                    id="teamDescription"
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Enter Team Description"
                    size="50"
                ></textarea>
                {errorMessage.map(
                    item =>
                        item.field === "Description" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
            </div>

            <div className={css.footer}>
                <Button
                    handleClick={() => closeDrawer()}
                    className={"btn btn-light " + css.cancelButton}
                    value="Cancel"
                />
                <Button
                    handleClick={e => onSubmitClick(e)}
                    className={"btn btn-light " + css.submitButton}
                    value="Save"
                />
            </div>
        </div>
    );
};

export default AddTeam;
