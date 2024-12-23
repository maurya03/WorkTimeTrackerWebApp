import { getApi } from 'rootpath/services/baseApiService';

export const fetchStates = async () => {
  const apiURL = 'https://cdn-api.co-vin.in/api/v2/admin/location/states';
  //all api result manupulation has to be done here and then only
  //return that portion of data needs to be updated in UI
  const response = await getApi(apiURL);
  return response;
};
