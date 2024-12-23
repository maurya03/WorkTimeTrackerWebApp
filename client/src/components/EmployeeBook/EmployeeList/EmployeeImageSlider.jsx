import React from "react";
import { Box, Typography } from "@mui/material";
import SliderImages from "rootpath/components/EmployeeBook/EmployeeList/SliderImages";
import "bootstrap/dist/css/bootstrap.min.css";
import ReadMoreText from "rootpath/components/EmployeeBook/EmployeeList/ReadMoreText";
import useMediaQuery from "@mui/material/useMediaQuery";
const employeeBookContent = ` Introduction: Welcome to our Employee Book! We are excited to
offer you this platform that allows you to connect with your
colleagues in a meaningful way. The Employee Book is a
comprehensive resource that not only provides details of each
employee, but also helps you to get to know your colleagues
better. Whether it's hobbies, interests, or past experiences,
you can find it all in one place. We understand the importance
of building strong relationships with your co-workers and this
portal is designed to facilitate that. We encourage you to
explore the Employee Book and connect with your colleagues.
Let's continue to work together and build a supportive
community.`;
import image1 from "rootpath/assets/NavigationImages/1.png";
import image2 from "rootpath/assets/NavigationImages/2.png";
import image3 from "rootpath/assets/NavigationImages/3.png";
import image4 from "rootpath/assets/NavigationImages/4.png";
import image5 from "rootpath/assets/NavigationImages/5.png";
import image6 from "rootpath/assets/NavigationImages/6.png";
import image7 from "rootpath/assets/NavigationImages/7.png";
import image8 from "rootpath/assets/NavigationImages/8.png";
import Carousel from "react-bootstrap/Carousel";

const EmployeeImageSlider = ({ isListView }) => {
    const isMobile = useMediaQuery("(max-width: 767px)");
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
        <>
            {isListView && (
                <>
                    {/* <Carousel>
                        {imageList.map((img, i) => {
                            return (
                                <Carousel.Item interval={1500}>
                                    <img
                                        className="d-block w-100"
                                        src={img}
                                        alt="Image One"
                                    />
                                </Carousel.Item>
                            );
                        })}
                    </Carousel> */}
                    <Box
                        id="carouselExampleIndicators"
                        className="carousel slide"
                        data-bs-ride="carousel"
                    >
                        <SliderImages />
                        <a
                            className="carousel-control-prev"
                            data-bs-target="#carouselExampleIndicators"
                            role="button"
                            data-bs-slide="prev"
                        >
                            <span
                                className="carousel-control-prev-icon"
                                aria-hidden="true"
                            ></span>
                        </a>
                        <a
                            className="carousel-control-next"
                            data-bs-target="#carouselExampleIndicators"
                            role="button"
                            data-bs-slide="next"
                        >
                            <span
                                className="carousel-control-next-icon"
                                aria-hidden="true"
                            ></span>
                        </a>
                    </Box>
                    {/* <div
                        id="carouselExampleControls"
                        class="carousel slide"
                        data-bs-ride="carousel"
                    >
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img
                                    src={image1}
                                    class="d-block w-100"
                                    alt="..."
                                />
                            </div>
                            <div class="carousel-item">
                                <img
                                    src={image2}
                                    class="d-block w-100"
                                    alt="..."
                                />
                            </div>
                            <div class="carousel-item">
                                <img
                                    src={image3}
                                    class="d-block w-100"
                                    alt="..."
                                />
                            </div>
                        </div>
                        <button
                            class="carousel-control-prev"
                            type="button"
                            data-bs-target="#carouselExampleControls"
                            data-bs-slide="prev"
                        >
                            <span
                                class="carousel-control-prev-icon"
                                aria-hidden="true"
                            ></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button
                            class="carousel-control-next"
                            type="button"
                            data-bs-target="#carouselExampleControls"
                            data-bs-slide="next"
                        >
                            <span
                                class="carousel-control-next-icon"
                                aria-hidden="true"
                            ></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div> */}
                    <Typography
                        p="10px"
                        mt="15px"
                        mb="25px"
                        borderRadius="10px"
                        color="#000"
                        fontWeight="400"
                        sx={{ backgroundColor: "#e9ebee" }}
                    >
                        {isMobile ? (
                            <ReadMoreText content={employeeBookContent} />
                        ) : (
                            employeeBookContent
                        )}
                    </Typography>
                </>
            )}
        </>
    );
};
export default EmployeeImageSlider;
