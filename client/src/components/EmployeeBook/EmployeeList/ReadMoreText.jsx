import React, { useState } from "react";
import Link from "@mui/material/Link";

const ReadMoreText = ({ content, initialLines = 3 }) => {
    const [isTruncated, setIsTruncated] = useState(true);
    const toggleTruncation = () => setIsTruncated(!isTruncated);
    const truncatedContent = content
        .split(/\n/)
        .slice(0, initialLines)
        .join("\n");
    const fullContent = content;

    return (
        <>
            {isTruncated ? (
                <>
                    {truncatedContent}
                    <br />
                    <Link component="button" onClick={toggleTruncation}>
                        {" "}
                        Read More
                    </Link>
                </>
            ) : (
                <>
                    {fullContent}
                    <br />
                    <Link component="button" onClick={toggleTruncation}>
                        {" "}
                        Show Less
                    </Link>
                </>
            )}
        </>
    );
};
export default ReadMoreText;
