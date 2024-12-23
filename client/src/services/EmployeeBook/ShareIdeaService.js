import { getApi, postApi } from "rootpath/services/baseApiService";

export const getIdeaCategories = async () => {
    const baseURL = `GetIdeaCategory`;
    const response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const getShareIdeaQuestions = async () => {
    const baseURL = `GetQuestions`;
    const response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const saveIdea = async (categoryId, questionAnswers) => {
    const obj = {
        shareIdeas: questionAnswers,
        categoryId: categoryId
    };
    const baseURL = "AddIdea";
    const response = await postApi(baseURL, obj)
        .then(res => {
            if (res.status == "200") {
                return { success: res };
            }
        })
        .catch(error => {
            console.log(error);
            return { error: error };
        });
    return response;
};

export const getShareIdeaCountsWithCategory = async () => {
    const baseURL = `GetShareIdeaCountsWithCategory`;
    const response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const getEmployeeShareIdea = async () => {
    const baseURL = `GetEmployeeShareIdeas`;
    const response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const validateShareIdea = (categoryId, questionAnswer) => {
    let validationSummary = {
        isValid: true,
        errorMessage: "",
        severity: "error"
    };
    if (categoryId == null) {
        validationSummary.errorMessage = "Please select atleast one category";
        validationSummary.isValid = false;
    }
    if (questionAnswer.every(item => item.answer === "")) {
        validationSummary.errorMessage = "Please answer atleast one question";
        validationSummary.isValid = false;
    }

    return validationSummary;
};

export const addOrReplaceQuestionAnswer = (arr, obj) => {
    const index = arr.findIndex(e => e.questionId === obj.questionId);

    if (index === -1) {
        arr.push(obj);
    } else {
        arr[index] = obj;
    }
    return arr;
};

export const shareIdeaCountsWithCategoryColumns = [
    {
        title: "Id",
        field: "categoryId",
        sortable: true
    },
    {
        title: "Category",
        field: "category",
        sortable: true
    },
    {
        title: "Idea Counts",
        field: "ideaCounts",
        sortable: false
    }
];
