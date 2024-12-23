import React, { useState, useEffect, useRef } from "react";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import { ArrowLeft, ArrowRight } from "@material-ui/icons";
import Button from "rootpath/components/SkillMatrix/Button/Button";
const ScoreMappingClient = ({ clients, setActiveClient, activeClient }) => {
    const containerRefClient = useRef();

    useEffect(() => {
        setActiveClient(clients[0] || null);
    }, [clients]);
    const handleClientScroll = scrollAmount => {
        const newScrollPosition =
            containerRefClient.current.scrollLeft + scrollAmount;
        containerRefClient.current.scrollLeft = newScrollPosition;
    };
    return (
        <div className={styles.clientContainer}>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleClientScroll(-200)}
            >
                <ArrowLeft />
            </button>
            <div ref={containerRefClient} className={styles.scrollClient}>
                <div className={styles.contentBox}>
                    {clients &&
                        clients.map(client => (
                            <div className={styles.scrollItems}>
                                <Button
                                    title={client.clientName}
                                    className={
                                        (client.clientName ===
                                        activeClient.clientName
                                            ? "btn btn-primary "
                                            : "btn btn-light ") +
                                        styles.clientButton
                                    }
                                    value={client.clientName}
                                    handleClick={() => setActiveClient(client)}
                                />
                            </div>
                        ))}
                </div>
            </div>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleClientScroll(200)}
            >
                <ArrowRight />
            </button>
        </div>
    );
};
export default ScoreMappingClient;
