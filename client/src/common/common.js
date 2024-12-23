export const InterestList = [
    {
        value: "All",
        text: "All"
    },
    {
        value: "Coding",
        text: "Coding"
    },
    {
        value: "Cooking",
        text: "Cooking"
    },
    {
        value: "Cricket",
        text: "Cricket"
    },
    {
        value: "Dance",
        text: "Dance"
    },
    {
        value: "Fitness",
        text: "Fitness"
    },
    {
        value: "Internet",
        text: "Internet Surfing"
    },
    {
        value: "Singing",
        text: "Singing"
    },
    {
        value: "Sports",
        text: "Sports"
    },
    {
        value: "Traveling",
        text: "Traveling"
    },
    {
        value: "Vlogging",
        text: "Vlogging"
    }
];

export const SortByList = [
    {
        value: "NameAsc",
        text: "Name (a to z)"
    },
    {
        value: "NameDesc",
        text: "Name (z to a)"
    }
];

export const next = (
    data,
    currentItem,
    setIsArrowBackDisable,
    setIsArrowFrontDisable,
    setCurrentPage
) => {
    const recordIndexToShow = currentItem.id + 1;
    const obj = data.model.find(record => record.id === recordIndexToShow);
    if (obj) {
        if (data.model.length - 1 === recordIndexToShow)
            setIsArrowFrontDisable(true);
        else {
            setIsArrowFrontDisable(false);
        }
        setCurrentPage(recordIndexToShow + 1);
        setIsArrowBackDisable(false);
        return obj;
    }
    return currentItem;
};

export const previous = (
    data,
    currentItem,
    setIsArrowBackDisable,
    setIsArrowFrontDisable,
    setCurrentPage
) => {
    const recordIndexToShow = currentItem.id - 1;
    const obj = data.model.find(record => record.id === recordIndexToShow);
    if (obj) {
        if (recordIndexToShow === 0) setIsArrowBackDisable(true);
        else {
            setIsArrowBackDisable(false);
        }
        setIsArrowFrontDisable(false);
        setCurrentPage(recordIndexToShow + 1);
        return obj;
    }
    return currentItem;
};
