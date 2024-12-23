import React, { useState, useEffect, useRef } from "react";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import { ArrowLeft, ArrowRight } from "@material-ui/icons";
import Button from "rootpath/components/SkillMatrix/Button/Button";
const ScoreMappingTeams = ({ teams, setActiveTeam, activeTeam }) => {
    const containerRefTeam = useRef();

    useEffect(() => {
        setActiveTeam(teams[0] || null);
    }, [teams]);
    const handleTeamScroll = scrollAmount => {
        const newScrollPosition =
            containerRefTeam.current.scrollLeft + scrollAmount;
        containerRefTeam.current.scrollLeft = newScrollPosition;
    };
    return (
        <div className={styles.clientContainer}>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleTeamScroll(-200)}
            >
                <ArrowLeft />
            </button>
            <div ref={containerRefTeam} className={styles.scrollClient}>
                <div className={styles.contentBox}>
                    {teams.map(team => (
                        <div className={styles.scrollItems}>
                            <Button
                                title={team.teamName}
                                className={
                                    (team.teamName === activeTeam.teamName
                                        ? "btn btn-primary "
                                        : "btn btn-light ") +
                                    styles.clientButton
                                }
                                value={team.teamName}
                                handleClick={() => setActiveTeam(team)}
                            />
                        </div>
                    ))}
                </div>
            </div>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleTeamScroll(200)}
            >
                <ArrowRight />
            </button>
        </div>
    );
};
export default ScoreMappingTeams;
