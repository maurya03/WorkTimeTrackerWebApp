import {
    delApi,
    getApi,
    postApi,
    patchApi,
    putApi
} from "rootpath/services/baseApiService";

const baseURL = "api/v1";
export const getTimesheetDetail = async entryid => {
    const url = `${baseURL}/gettimesheetbyentryid/timesheetId/${entryid}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const TimeSheetDetailByDates = async dates => {
    const url = `${baseURL}/gettimesheetbydates/startDate/${dates.startDate}/endDate/${dates.endDate}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const TimeSheetDetailCreatedOnBehalf = async request => {
    const url = `${baseURL}/gettimesheetdetailcreatedonbehlaf?startDate=${request.startDate}&endDate=${request.endDate}&IsBehalf=${request.isBehalf}&empId=${request.empId}&clientId=${request.clientId}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const getTimesheet = async data => {
    const url = `${baseURL}/getTimesheetStatusWise`;
    const response = await postApi(url, data)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const GetEmployeeProjectApi = async () => {
    const url = `${baseURL}/getemployeeprojects`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const GetProjectsForOnBehalfEmployeeApi = async empId => {
    const url = `${baseURL}/getProjectsForOnBehalfEmployees/employeeId/${empId}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const GetTimesheetCategoryApi = async () => {
    const url = `${baseURL}/timesheetCategories`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const GetTimesheetSubCategoryApi = async () => {
    const url = `${baseURL}/timesheetSubCategory`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const GetTimesheetEmployeeApi = async projectId => {
    const url = projectId
        ? `${baseURL}/gettimesheetemployeebyprojectid/projectId/${projectId}`
        : `${baseURL}/gettimesheetemployee`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const PostTimeSheetApi = async (data, actionName) => {
    const isDeleted = actionName === "Deleted" ? true : false;
    const url = `${baseURL}/savetimesheet?isDeleted=${isDeleted}`;
    const response = await postApi(url, data)
        .then(res => {
            return res.data;
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const UpdateTimeSheetStatusApi = async (
    data,
    selectedEmailListAndWeek
) => {
    const url = `api/v1/updateTimesheetStatusForEmployee`;
    const response = await patchApi(url, data)
        .then(res => {
            SendEmails(selectedEmailListAndWeek);
            return res;
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const SubmitTimesheetonbehalf = async (
    empId,
    data,
    selectedEmailListAndWeek
) => {
    const url = `api/v1/submitTimesheetonbehalf/employeeId/${empId}`;
    const response = await patchApi(url, data)
        .then(res => {
            SendEmails(selectedEmailListAndWeek);
            return res;
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const SendEmails = async selectedEmailListAndWeek => {
    const url = `${baseURL}/sendemail`;
    const response = await postApi(url, selectedEmailListAndWeek)
        .then(res => {
            return res.data;
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const UpdateTimesheetStatusByReviewer = async (
    data,
    selectedEmailListAndWeek
) => {
    const url = `api/v1/updateTimesheetStatusForApprover`;
    const response = await patchApi(url, data)
        .then(res => {
            SendEmails(selectedEmailListAndWeek);
            return res;
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const updateEmployeeDetail = async employeeDetails => {
    const url = `${baseURL}/timesheetemployeedetails`;
    const response = await putApi(url, employeeDetails)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const bulkUpdateEmployeeDetail = async bulkEmployeeDetails => {
    const url = `${baseURL}/timesheetemployeedetailslist`;
    const response = await putApi(url, bulkEmployeeDetails)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
export const GetEmployeeDetailsByTeamId = async teamId => {
    const url = `${baseURL}/getemployeedetailbyteamid/teamId/${teamId}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const GetApprovalList = async (clientId, teamId) => {
    const url = `${baseURL}/timesheetapproval/projectId/${clientId}/team/${teamId}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const getTimesheetStatusList = async () => {
    const url = `${baseURL}/getTimesheetStatuses`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const getManagerAndApproverByEmployeeId = async empId => {
    const url = `${baseURL}/getManagerAndApprover/employeeid/${empId}`;
    const response = await getApi(url)
    .then(res => {
        if (res.data.length > 0) return res.data;
        else return [];
    })
    .catch(error => {
        return error;
    });
return response;
};

export const fetchTimesheetEmailData = async emailData => {
    const url = `${baseURL}/getTimesheetEmailData`;
    const response = await postApi(url, emailData)
        .then(res => {
            if(res?.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const sendEmailNotification = async emailData => {
    const url = `${baseURL}/sendEmailNotification`;
    const response = await postApi(url, emailData)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
