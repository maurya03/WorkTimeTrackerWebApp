import { Bar } from "react-chartjs-2";
import React from "react";

export const BarChart = ({ chartData }) => {
    return (
        <div className="chart-container">
            <Bar
                scales
                data={chartData}
                options={{
                    scales: {
                        y: {
                            title: {
                                display: true,
                                text: "Employees Count"
                            },

                            ticks: {
                                beginAtZero: true,
                                stepSize: 1,
                                precision: 0
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: "Date/Week/Month as per filter select"
                            }
                        }
                    }
                }}
            />
        </div>
    );
};
