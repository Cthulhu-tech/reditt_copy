import { useEffect, useState } from "react";

export const useFetch = (method: string = 'POST') => {

    const [data, setData] = useState<any>();
    const [errorResponse, setError] = useState<Error>();
    const [load, setLoad] = useState(true);

    const FetchData = (url: string, _body: {[key: string]: string} = {}) => {
        console.log('f')
        let params: RequestInit = {

            method: method,
            mode: 'cors',
            redirect: 'follow',
            credentials: "include",
            headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json'
            }

        }

        if(Object.keys(_body).length > 0){

            params.body = JSON.stringify(_body)

        }

        fetch(process.env.REACT_APP_SERVER + url, params)
        .then((response) => {

            return response.json();

        }).then((json) => {
            console.log(json)
            setLoad(false);
            return setData(json);

        }).catch((err) => {
            console.log(err)
            setLoad(false);
            return setError(err);

        })

    }

    useEffect(() => {}, []);

    return {load, data, errorResponse, FetchData};

}