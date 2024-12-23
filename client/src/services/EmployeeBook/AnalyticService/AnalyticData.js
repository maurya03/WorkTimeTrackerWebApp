export const filterOptions = [
    { value: "Daily", label: "Daily" },
    { value: "Weekly", label: "Weekly" },
    { value: "Monthly", label: "Monthly" }
];

export const barChartObject = (labelRecords, records) => {
    return {
        labels: labelRecords,
        datasets: [
            {
                label: "No of Employee Login",
                data: records,
                backgroundColor: ["#59c1cf"],
                borderColor: "#000000",
                borderWidth: 2
            }
        ]
    };
};

export const getChartObject = chartRecords => {
    let response = {};
    if (
        chartRecords !== undefined &&
        Object.keys(chartRecords).length !== 0 &&
        chartRecords.loginCountModel.length > 0
    ) {
        const xAxisData = chartRecords.loginCountModel.map(model =>
            model.label.replace(" 00:00:00", "")
        );
        const data = chartRecords.loginCountModel.map(
            model => model.loginCount
        );
        response = {
            labels: xAxisData,
            datasets: [
                {
                    label: "No of Employee Login",
                    data: data,
                    backgroundColor: ["#159c49", "#213f93"],
                    borderColor: "#000000",
                    borderWidth: 1
                }
            ]
        };
    }
    return response;
};

export const googleAnalyticsColumns = [
    {
        title: "Country",
        field: "country"
    },
    {
        title: "City",
        field: "city"
    },
    {
        title: "Audience Name",
        field: "audienceName"
    },
    {
        title: "Event Name",
        field: "eventName"
    },
    {
        title: "Unified Screen Name",
        field: "unifiedScreenName"
    },
    {
        title: "Active Users",
        field: "activeUsers"
    },
    {
        title: "Event Count",
        field: "eventCount"
    },
    {
        title: "Screen Page Views",
        field: "screenPageViews"
    }
];

export const logColumns = [
    {
        title: "Id",
        field: "id",
        sortable: true
    },
    {
        title: "Logs",
        field: "description",
        sortable: false
    },
    {
        title: "Created Date",
        field: "createdDate",
        sortable: true
    }
];

export const modifiersStyles = {
    currentWeek: {
        color: "white",
        backgroundColor: "green"
    },
    disabled: {
        color: "grey"
    }
};
export const styles = {
    caption: { color: "green", fontWeight: "bold" },
    head_cell: { color: "green" },
    day: {
        color: "black",
        border: "none",
        background: "none"
    }
};
