import React, { useState, useEffect } from "react";
import css from "rootpath/styles/formStyles.css";
import { ClientPostApi } from "rootpath/services/SkillMatrix/ClientService/ClientService";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import { validationInput } from "rootpath/components/SkillMatrix/commonValidationFunction";
import CustomAlert from "rootpath/components/CustomAlert";

const AddClient = ({
    fetchClientList,
    setclientFormVisible,
    setShowDrawer,
    showDrawer,
    clientFormVisible,
    setIsEdit,
    updateClient,
    selectedClient,
    setShowAlert,
    showAlert
}) => {
    const [client, setClient] = useState({
        clientName: selectedClient?.clientName || "",
        clientDescription: selectedClient?.clientDescription || "",
        createdOn: new Date().toJSON(),
        modifiedOn: new Date().toJSON()
    });
    const [errorMessage, setErrorMessage] = useState([]);
    useEffect(async () => {
        setClient(client);
    }, [selectedClient]);
    const handlechange = e => {
        setClient(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
    };
    const addClient = async state => {
        var result = await ClientPostApi(state);
        if (result) {
            const flag = showErrorMessage(result);
            flag === true &&
                setShowAlert(true, "success", "Client added successfully!");
        }
    };

    const showErrorMessage = result => {
        if (result?.success) {
            fetchClientList();
            closeDrawer();
            return true;
        } else {
            let errorArray = [];
            result.error.response.data.map(item => {
                errorArray.push({ error: item.errorMessage, field: "name" });
            });
            setShowAlert(true, "error", `${errorArray[0].error}`);
            return false;
        }
    };

    const updateClientRecord = async state => {
        var result = await updateClient(state);
        if (result) {
            const flag = showErrorMessage(result);
            flag === true &&
                setShowAlert(true, "success", "Client updated successfully!");
        }
    };

    const closeDrawer = () => {
        showAlert.setAlert === true && setShowAlert(false);
        setIsEdit(false);
        setclientFormVisible(!clientFormVisible);
        setShowDrawer(!showDrawer);
    };
    const onSubmitClick = () => {
        var validate = validationInput(client, "client");
        setErrorMessage(validate);
        if (validate.length === 0) {
            if (Object.keys(selectedClient).length > 0) {
                client.id = selectedClient.id;
                client.modifiedOn = new Date().toJSON();
                updateClientRecord(client);
            } else {
                addClient(client);
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

                <label className={css.label}>Client Name</label>
                <input
                    className={css.formInput}
                    defaultValue={selectedClient.clientName}
                    id={"clientName"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Enter Client Name"
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Name" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}

                <label className={css.label}>Client Description</label>
                <textarea
                    rows={7}
                    className={css.description}
                    defaultValue={selectedClient.clientDescription}
                    id={"clientDescription"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Enter Client Description"
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

export default AddClient;
