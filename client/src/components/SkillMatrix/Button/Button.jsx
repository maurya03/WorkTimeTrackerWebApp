import React from "react";
const Button = ({
    value,
    className,
    handleClick,
    selected
}
) => {
    return (
        <>
            <button
                title={value}
                disabled={
                    selected ? selected : false
                }
                className={"btn btn-primary " + className}
                type="submit"
                onClick={handleClick}
            >
                {value}
            </button>
        </>
    )


}
export default Button;