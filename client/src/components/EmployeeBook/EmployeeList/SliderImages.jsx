import React from "react";
import { Box } from "@mui/material";
import cx from "classnames";
import image1 from "rootpath/assets/NavigationImages/1.png";
import image2 from "rootpath/assets/NavigationImages/2.png";
import image3 from "rootpath/assets/NavigationImages/3.png";
import image4 from "rootpath/assets/NavigationImages/4.png";
import image5 from "rootpath/assets/NavigationImages/5.png";
import image6 from "rootpath/assets/NavigationImages/6.png";
import image7 from "rootpath/assets/NavigationImages/7.png";
import image8 from "rootpath/assets/NavigationImages/8.png";

const SliderImages = () => {
    const imageList = [
        image1,
        image2,
        image3,
        image4,
        image5,
        image6,
        image7,
        image8
    ];

    return (
        <Box borderRadius="10px" className="carousel-inner">
            {imageList.map((img, i) => {
                return (
                    <Box
                        key={i}
                        className={cx("carousel-item", i === 1 && "active")}
                    >
                        <img className="d-block w-100" src={img} />
                    </Box>
                );
            })}
        </Box>
    );
};

export default SliderImages;
