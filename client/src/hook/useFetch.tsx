import { useEffect, useState } from "react";

export const useFetch = (method: string = 'POST') => {

    const [data, setData] = useState<any>();
    const [errorResponse, setError] = useState<Error>();
    const [load, setLoad] = useState(true);

    const FetchData = (url: string) => {

        fetch(process.env.REACT_APP_SERVER + url, {
            method: method,
            mode: 'cors',
            redirect: 'follow',
            credentials: "include",
            headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json'
            },
        }).then((response) => {

            return response.json();

        }).then((json) => {

            setLoad(false);
            return setData(json);

        }).catch((err) => {

            setLoad(false);
            return setError(err);

        })

    }

    useEffect(() => {}, []);

    return {load, data, errorResponse, FetchData};

}