import React, { useState } from "react";
import css from "rootpath/components/ImportData/ImportData.css";

const ImportData = ({
    orgRecords,
    postExcelRecord,
    postItHoursRecord,
    emptyRecords
}) => {
    const [selectedFile, setSelectedFile] = useState(null);
    const [selectedLeave, setSelectedLeave] = useState(null);
    const [isUploading, setIsUploading] = useState(false);
    const [showLabel, setShowLabel] = useState(false);
    
    const handleLeaveImport = event => {
        emptyRecords();
        setSelectedLeave(event.target.files[0]);
    };

    const handleHoursImport = event => {
        emptyRecords();
        setSelectedFile(event.target.files[0]);
    };

    const handleSubmit = async event => {
        emptyRecords();
        event.preventDefault();
        setIsUploading(true);
        if (selectedFile == null && selectedLeave == null) {
            setShowLabel(true);
        }
        try {
            await postItHoursRecord(selectedFile);
            await postExcelRecord(selectedLeave);
        } catch (error) {
            console.error("Upload error:", error);
        } finally {
            setIsUploading(false);
        }
    };
    return (
        <div className="container">
            <div className={css.contentHeader}>
                <div className={css.title}>Import Excel</div>
            </div>
            <div className={css.dashboardView}>
                <div className={css.clientContainer}>
                    <div className={css.alignHeading}>
                        <h4>Leaves Data : </h4>
                        <input type="file" onChange={handleLeaveImport} />
                        {selectedLeave != null ||
                            (showLabel && (
                                <p className={css.redText}>
                                    Please Import the excel first
                                </p>
                            ))}
                    </div>

                    <div className={css.alignHeading}>
                        <h4>ITHours Data : </h4>
                        <input type="file" onChange={handleHoursImport} />
                        {selectedFile != null ||
                            (showLabel && (
                                <p className={css.redText}>
                                    Please Import the excel first
                                </p>
                            ))}
                    </div>
                    <button
                        disabled={
                            !selectedFile ||
                            isUploading ||
                            !selectedLeave                           
                        }
                        onClick={handleSubmit}
                    >
                        Upload!
                    </button>
                </div>
            </div>
            {orgRecords.length > 0 && (
                <div>
                    <label>THE FILE IS UPLOADED SUCCESSFULLY!</label>
                </div>
            )}
        </div>
    );
};

export default ImportData;
