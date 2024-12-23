import React from "react";
import { ResponsiveBar } from "@nivo/bar";
import {ResponsiveLine } from "@nivo/line";
import { useTheme } from "@mui/material";
import { tokens } from "rootpath/components/SkillMatrix/Dashboard/theme";

const BarChart = ({
    isDashboard = false,
    barData = [],
    fetchBarDataTeamWise,
    chartType
}) => {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const lineData = [
        {
            "id": "Score",
            "color": "hsl(237, 70%, 50%)",
            "data": [
              {
                "x": "Mercell",
                "y": 45
              }
            ]
            }
        
        // Add more data points as needed
    ];
    const getColor = (bar) => {
        // Check if the column name contains "QA"
    if (chartType === "ScoreWise" && bar.indexValue.includes("QA")) {
        return "rgb(21, 156, 73)"; // Yellow color for columns containing "QA"
        } else {
            return "rgb(31, 119, 180)"; // Default color scheme             colors={}
        }
    };
    let columnName = [];
    if (barData.length > 0) {
        barData.forEach(item => {
            if (columnName.length >= 0) {
                const keys = Object.keys(item);
                if (columnName.length == 0) {
                    columnName = keys;
                } else {
                    columnName = [
                        ...columnName,
                        ...keys.filter(element => !columnName.includes(element))
                    ];
                }
                let index = columnName.indexOf(
                    chartType == "CategoryWise" ? "CategoryName" : "TeamName"
                );
                if (index !== -1) {
                    columnName.splice(index, 1);
                }
            }
        });
    }
    return (
        
        <ResponsiveBar
            data={barData}
            theme={{
                text: {
                    fill: "#fff",
                    fontSize: 20
                },
                axis: {
                    domain: {
                        line: {
                            stroke: colors.grey[100]
                        }
                    },
                    legend: {
                        text: {
                            fill: colors.grey[100],
                            fontSize: "16px"
                        }
                    },
                    ticks: {
                        line: {
                            stroke: colors.grey[100],
                            strokeWidth: 1
                        },
                        text: {
                            fill: colors.grey[100],
                            fontSize: "16px"
                        }
                    }
                },
                legends: {
                    text: {
                        fill: colors.grey[100],
                        fontSize: "14px"
                    }
                },
                tooltip: {
                    container: {
                        background: colors.primary[400],
                        color: colors.grey[100]
                    }
                }
            }}
            keys={columnName.filter(v => v !== 'EmployeeCount')}
            indexBy={chartType == "CategoryWise" ? "CategoryName" : "TeamName"}
            margin={{ top: 50, right: 140, bottom: 130, left: 0 }}
            padding={0.4}
            innerPadding={1}
            valueScale={{ type: "linear" }}
            indexScale={{ type: "band", round: true }}
            valueFormat=" <-"
            colors={{ scheme: "category10" }}
            defs={[
                {
                    id: "dots",
                    type: "patternDots",
                    background: "inherit",
                    color: "#38bcb2",
                    size: 4,
                    padding: 1,
                    stagger: true
                },
                {
                    id: "lines",
                    type: "patternLines",
                    background: "inherit",
                    color: "#eed312",
                    rotation: -45,
                    lineWidth: 6,
                    spacing: 10
                }
            ]}
            fill={[
                {
                    match: {
                        id: "fries"
                    },
                    id: "dots"
                },
                {
                    match: {
                        id: "sandwich"
                    },
                    id: "lines"
                }
            ]}
            borderRadius={1}
            borderColor={{
                from: "color",
                modifiers: [["darker", "1.1"]]
            }}
            axisTop={null}
            axisRight={null}
            axisBottom={{
                tickSize: 5,
                tickPadding: 5,
                legend: isDashboard ? undefined : "TeamName",
                legendPosition: "middle",
                legendOffset: 32,
                tickRotation: -45
            }}
            axisLeft={null}
            labelSkipWidth={10}
            labelSkipHeight={10}
            labelTextColor={{
                from: "color",
                modifiers: [["darker", 30]]
            }}
            onClick={fetchBarDataTeamWise}
            legends={[
                {
                    dataFrom: "keys",
                    anchor: "bottom-right",
                    direction: "column",
                    justify: false,
                    translateX: 120,
                    translateY: 0,
                    itemsSpacing: 6,
                    itemWidth: 100,
                    itemHeight: 20,
                    itemDirection: "left-to-right",
                    itemOpacity: 0.85,
                    symbolSize: 20,
                    effects: [
                        {
                            on: "hover",
                            style: {
                                itemOpacity: 1
                            }
                        }
                    ]
                }
            ]}
            role="application"
            ariaLabel="Skill matrix bar chart"
            barAriaLabel={function (e) {
                return (
                    e.id +
                    ": " +
                    e.formattedValue +
                    " in technology: " +
                    e.indexValue
                );
            }}
            layers={[
                "grid",
                "axes",
                "bars",
                "markers",
                "legends",
                ({ bars }) => (
                    <g>
                        {bars.map((bar,index) => (
                           
                            
                            <g key={bar.key}>
                               {chartType != "TeamWise" && bar && bar.data.data.EmployeeCount &&   
                               <>
                                <rect
                                    key={bar.key}
                                    x={bar.x}
                                    y={bar.y - 40} // Adjust the y position as needed
                                    width={bar.width}
                                    height={40} // Adjust the height as needed
                                    fill="#d4c9b2" // Color of the box
                                    fillOpacity={0.7} // Opacity of the box
                                    rx={4} // Rounded corners
                                />

                                <text
                                    x={bar.x + bar.width / 2}
                                    y={bar.y - 20} // Adjust the y position as needed
                                    textAnchor="middle"
                                    dominantBaseline="middle"
                                    fill="#000000" // Color of the text
                                    fontSize={16} // Font size of the text
                                    fontWeight= "bold"
                                >
                                    
                                    {bar.data.data.EmployeeCount} 
                                </text>
                                </>
            }
                            </g>
                           
                        ))}
                    </g>
                )
            ]}
        />


    
   
    );
};

export default BarChart;
